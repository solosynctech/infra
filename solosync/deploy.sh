#!/usr/bin/env bash
set -euo pipefail
CLOUD=${1:-}
: "${BACKEND_IMAGE:?Set BACKEND_IMAGE}"
: "${FRONTEND_IMAGE:?Set FRONTEND_IMAGE}"

case "$CLOUD" in
  gcp)
    : "${GCP_PROJECT:?Set GCP_PROJECT}"
    : "${GCP_REGION:?Set GCP_REGION}"
    gcloud run deploy solosync-backend --project "$GCP_PROJECT" --region "$GCP_REGION" --image "$BACKEND_IMAGE" --allow-unauthenticated
    gcloud run deploy solosync-frontend --project "$GCP_PROJECT" --region "$GCP_REGION" --image "$FRONTEND_IMAGE" --allow-unauthenticated
    echo "Deploy WAHA separately on a private persistent host; set the backend WAHA_URL to that private endpoint."
    echo "Homepage is deployed through GitHub Pages."
    ;;
  azure)
    : "${AZURE_RESOURCE_GROUP:?Set AZURE_RESOURCE_GROUP}"
    : "${AZURE_ENVIRONMENT:?Set AZURE_ENVIRONMENT}"
    : "${AZURE_LOCATION:?Set AZURE_LOCATION}"
    az containerapp env create --name "$AZURE_ENVIRONMENT" --resource-group "$AZURE_RESOURCE_GROUP" --location "$AZURE_LOCATION" >/dev/null 2>&1 || true
    az containerapp create --name solosync-backend --resource-group "$AZURE_RESOURCE_GROUP" --environment "$AZURE_ENVIRONMENT" --image "$BACKEND_IMAGE" --target-port 4000 --ingress external --env-vars "MONGODB_URI=$MONGODB_URI" "REDIS_URL=$REDIS_URL" "JWT_SECRET=$JWT_SECRET" "FRONTEND_ORIGIN=$FRONTEND_ORIGIN" "WAHA_URL=$WAHA_URL" "WAHA_API_KEY=$WAHA_API_KEY" "BILLING_ENABLED=$BILLING_ENABLED"
    az containerapp create --name solosync-frontend --resource-group "$AZURE_RESOURCE_GROUP" --environment "$AZURE_ENVIRONMENT" --image "$FRONTEND_IMAGE" --target-port 80 --ingress external
    echo "Deploy WAHA separately on a private persistent host."
    echo "Homepage is deployed through GitHub Pages."
    ;;
  oci)
    : "${OCI_COMPARTMENT_ID:?Set OCI_COMPARTMENT_ID}"
    : "${OCI_SUBNET_ID:?Set OCI_SUBNET_ID}"
    : "${OCI_BACKEND_IMAGE:?Set OCI_BACKEND_IMAGE}"
    oci container-instances container-instance create --compartment-id "$OCI_COMPARTMENT_ID" --display-name solosync-backend --containers "[{\"imageUrl\":\"$OCI_BACKEND_IMAGE\",\"displayName\":\"backend\",\"environmentVariables\":[{\"name\":\"MONGODB_URI\",\"value\":\"$MONGODB_URI\"},{\"name\":\"REDIS_URL\",\"value\":\"$REDIS_URL\"},{\"name\":\"JWT_SECRET\",\"value\":\"$JWT_SECRET\"},{\"name\":\"FRONTEND_ORIGIN\",\"value\":\"$FRONTEND_ORIGIN\"},{\"name\":\"WAHA_URL\",\"value\":\"$WAHA_URL\"},{\"name\":\"WAHA_API_KEY\",\"value\":\"$WAHA_API_KEY\"},{\"name\":\"BILLING_ENABLED\",\"value\":\"$BILLING_ENABLED\"}]}]" --vnics "[{\"subnetId\":\"$OCI_SUBNET_ID\",\"isPublicIpAssigned\":true}]"
    echo "Deploy frontend and private WAHA separately."
    echo "Homepage is deployed through GitHub Pages."
    ;;
  *)
    echo "Usage: $0 {gcp|azure|oci}"
    exit 2
    ;;
esac
