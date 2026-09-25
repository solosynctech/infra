#!/usr/bin/env bash
set -euo pipefail
CLOUD=${1:-}
: "${BACKEND_IMAGE:?Set BACKEND_IMAGE}" 
: "${FRONTEND_IMAGE:?Set FRONTEND_IMAGE}"
: "${HOME_IMAGE:?Set HOME_IMAGE}"
case "$CLOUD" in
 gcp)
  : "${GCP_PROJECT:?Set GCP_PROJECT}"
  : "${GCP_REGION:?Set GCP_REGION}"
  gcloud run deploy solosync-backend --project "$GCP_PROJECT" --region "$GCP_REGION" --image "$BACKEND_IMAGE" --allow-unauthenticated
  gcloud run deploy solosync-frontend --project "$GCP_PROJECT" --region "$GCP_REGION" --image "$FRONTEND_IMAGE" --allow-unauthenticated
  gcloud run deploy solosync-home --project "$GCP_PROJECT" --region "$GCP_REGION" --image "$HOME_IMAGE" --allow-unauthenticated
  ;;
 azure)
  : "${AZURE_RESOURCE_GROUP:?Set AZURE_RESOURCE_GROUP}"
  : "${AZURE_ENVIRONMENT:?Set AZURE_ENVIRONMENT}"
  : "${AZURE_LOCATION:?Set AZURE_LOCATION}"
  az containerapp env create --name "$AZURE_ENVIRONMENT" --resource-group "$AZURE_RESOURCE_GROUP" --location "$AZURE_LOCATION" >/dev/null 2>&1 || true
  az containerapp create --name solosync-backend --resource-group "$AZURE_RESOURCE_GROUP" --environment "$AZURE_ENVIRONMENT" --image "$BACKEND_IMAGE" --target-port 4000 --ingress external --env-vars "MONGODB_URI=$MONGODB_URI" "REDIS_URL=$REDIS_URL" "JWT_SECRET=$JWT_SECRET" "FRONTEND_ORIGIN=$FRONTEND_ORIGIN"
  az containerapp create --name solosync-frontend --resource-group "$AZURE_RESOURCE_GROUP" --environment "$AZURE_ENVIRONMENT" --image "$FRONTEND_IMAGE" --target-port 80 --ingress external
  az containerapp create --name solosync-home --resource-group "$AZURE_RESOURCE_GROUP" --environment "$AZURE_ENVIRONMENT" --image "$HOME_IMAGE" --target-port 80 --ingress external
  ;;
 oci)
  : "${OCI_COMPARTMENT_ID:?Set OCI_COMPARTMENT_ID}"
  : "${OCI_SUBNET_ID:?Set OCI_SUBNET_ID}"
  : "${OCI_IMAGE:?Set OCI_IMAGE to an OCIR image}"
  oci container-instances container-instance create --compartment-id "$OCI_COMPARTMENT_ID" --display-name solosync-backend --containers "[{\"imageUrl\":\"$OCI_IMAGE\",\"displayName\":\"backend\",\"environmentVariables\":[{\"name\":\"MONGODB_URI\",\"value\":\"$MONGODB_URI\"},{\"name\":\"REDIS_URL\",\"value\":\"$REDIS_URL\"},{\"name\":\"JWT_SECRET\",\"value\":\"$JWT_SECRET\"},{\"name\":\"FRONTEND_ORIGIN\",\"value\":\"$FRONTEND_ORIGIN\"}]}]" --vnics "[{\"subnetId\":\"$OCI_SUBNET_ID\",\"isPublicIpAssigned\":true}]"
  echo "Deploy frontend and homepage using the same OCI Container Instances command pattern and their images."
  ;;
 *) echo "Usage: $0 {gcp|azure|oci}"; exit 2;;
esac