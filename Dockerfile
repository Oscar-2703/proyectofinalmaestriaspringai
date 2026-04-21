# =========================
# 1. BUILD STAGE
# =========================
FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /app

# Copy only pom first (better caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Now copy source
COPY src ./src
RUN mvn clean package -DskipTests

# =========================
# 2. RUNTIME STAGE (SMALL)
# =========================
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

ENTRYPOINT ["java","-jar","app.jar"]