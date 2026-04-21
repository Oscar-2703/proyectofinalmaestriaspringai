#!/bin/bash

set -e

# =========================
# CONFIG
# =========================
PROJECT_ID="proyectofinalmaestria-493719"
REGION="us-central1"
SERVICE_NAME="backend"
IMAGE_NAME="backend"
REPOSITORY="repo"
BUCKET_NAME="${PROJECT_ID}-build-bucket"

IMAGE="$REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME"

# =========================
# 1. AUTH + CONFIG
# =========================
gcloud auth login
gcloud config set project $PROJECT_ID
gcloud config set run/region $REGION
gcloud config set artifacts/location $REGION

gcloud auth configure-docker $REGION-docker.pkg.dev -q

# =========================
# 2. ENSURE REGIONAL STORAGE BUCKET
# =========================
echo "🪣 Checking regional storage bucket..."

gcloud storage buckets describe gs://$BUCKET_NAME >/dev/null 2>&1 || \
gcloud storage buckets create gs://$BUCKET_NAME \
  --location=$REGION \
  --default-storage-class=STANDARD

# =========================
# 3. ENSURE ARTIFACT REGISTRY EXISTS
# =========================
echo "📦 Checking Artifact Registry repository..."

gcloud artifacts repositories describe $REPOSITORY \
  --location=$REGION >/dev/null 2>&1 || \
gcloud artifacts repositories create $REPOSITORY \
  --repository-format=docker \
  --location=$REGION \
  --description="Docker repo for backend"

# =========================
# 4. BUILD & PUSH IMAGE
# =========================
echo "🐳 Building container image..."

gcloud builds submit . \
  --tag $IMAGE \
  --gcs-source-staging-dir=gs://$BUCKET_NAME/source \
  --gcs-log-dir=gs://$BUCKET_NAME/logs

# =========================
# 5. DEPLOY TO CLOUD RUN
# =========================
echo "🚀 Deploying to Cloud Run..."

gcloud run deploy $SERVICE_NAME \
  --image $IMAGE \
  --set-secrets MONGODB_URI=MONGODB_URI:latest \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --memory 512Mi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 1 \
  --concurrency 80 \
  --timeout 60

# =========================
# 6. CLEAN OLD IMAGES (KEEP LAST 2)
# =========================
echo "🧹 Cleaning old images..."

IMAGES=$(gcloud artifacts docker images list \
  $REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME \
  --include-tags \
  --format="get(digest)" | tail -n +3)

for DIGEST in $IMAGES; do
  echo "Deleting image digest: $DIGEST"
  gcloud artifacts docker images delete \
    "$REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME@$DIGEST" \
    --quiet --delete-tags
done

# =========================
# DONE
# =========================
echo "✅ Deployment complete"

echo "🌐 Service URL:"
gcloud run services describe $SERVICE_NAME \
  --region $REGION \
  --format="value(status.url)"