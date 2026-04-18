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

IMAGE="$REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME"

# =========================
# 1. AUTH + CONFIG
# =========================
gcloud auth login
gcloud config set project $PROJECT_ID
gcloud config set run/region $REGION
gcloud config set artifacts/location $REGION

# Ensure Docker auth for Artifact Registry
gcloud auth configure-docker $REGION-docker.pkg.dev -q

# =========================
# 2. ENSURE ARTIFACT REGISTRY EXISTS
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
gcloud builds submit . --tag $IMAGE

# =========================
# 5. DEPLOY TO CLOUD RUN (FREE-TIER SAFE)
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
# DONE
# =========================
echo "✅ Deployment complete"

echo "🌐 Service URL:"
gcloud run services describe $SERVICE_NAME \
  --region $REGION \
  --format="value(status.url)"