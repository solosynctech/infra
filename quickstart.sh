#!/bin/bash

# Quick Start Script for Attach AI Infrastructure
# This script helps you get started with Terraform infrastructure setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "  Attach AI Infrastructure - Quick Start"
echo "================================================"
echo ""

# Check prerequisites
echo "Checking prerequisites..."
echo ""

# Check Terraform
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}✗ Terraform is not installed${NC}"
    echo "  Install from: https://www.terraform.io/downloads"
    exit 1
else
    TERRAFORM_VERSION=$(terraform version -json | grep -o '"terraform_version":"[^"]*' | cut -d'"' -f4)
    echo -e "${GREEN}✓ Terraform $TERRAFORM_VERSION${NC}"
fi

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    echo -e "${YELLOW}⚠ AWS CLI is not installed (optional but recommended)${NC}"
    echo "  Install from: https://aws.amazon.com/cli/"
else
    AWS_VERSION=$(aws --version | cut -d' ' -f1 | cut -d'/' -f2)
    echo -e "${GREEN}✓ AWS CLI $AWS_VERSION${NC}"
fi

echo ""
echo "================================================"
echo "  Setup Options"
echo "================================================"
echo ""
echo "Choose your setup:"
echo "  1) Development environment (minimal, cost-optimized)"
echo "  2) Staging environment (production-like)"
echo "  3) Production environment (full setup)"
echo "  4) Custom setup (create terraform.tfvars manually)"
echo ""
read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        ENV="dev"
        VAR_FILE="environments/dev/terraform.tfvars"
        echo -e "${GREEN}Selected: Development environment${NC}"
        ;;
    2)
        ENV="staging"
        VAR_FILE="environments/staging/terraform.tfvars"
        echo -e "${GREEN}Selected: Staging environment${NC}"
        ;;
    3)
        ENV="prod"
        VAR_FILE="environments/prod/terraform.tfvars"
        echo -e "${YELLOW}Selected: Production environment${NC}"
        echo -e "${YELLOW}Warning: This will create production resources and incur costs!${NC}"
        ;;
    4)
        echo -e "${GREEN}Selected: Custom setup${NC}"
        if [ ! -f terraform.tfvars ]; then
            cp terraform.tfvars.example terraform.tfvars
            echo "Created terraform.tfvars from example"
            echo -e "${YELLOW}Please edit terraform.tfvars before continuing${NC}"
            exit 0
        fi
        VAR_FILE="terraform.tfvars"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo "================================================"
echo "  Terraform Operations"
echo "================================================"
echo ""
echo "What would you like to do?"
echo "  1) Initialize Terraform"
echo "  2) Plan infrastructure changes"
echo "  3) Apply infrastructure changes"
echo "  4) Show current infrastructure"
echo "  5) Destroy infrastructure"
echo ""
read -p "Enter choice [1-5]: " operation

case $operation in
    1)
        echo ""
        echo "Initializing Terraform..."
        terraform init
        echo -e "${GREEN}✓ Terraform initialized${NC}"
        ;;
    2)
        echo ""
        echo "Planning infrastructure changes..."
        if [ -n "$VAR_FILE" ]; then
            terraform plan -var-file="$VAR_FILE"
        else
            terraform plan
        fi
        ;;
    3)
        echo ""
        echo -e "${YELLOW}This will create/modify AWS resources and may incur costs.${NC}"
        read -p "Are you sure? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            echo "Applying infrastructure changes..."
            if [ -n "$VAR_FILE" ]; then
                terraform apply -var-file="$VAR_FILE"
            else
                terraform apply
            fi
            echo -e "${GREEN}✓ Infrastructure applied${NC}"
            echo ""
            echo "To access outputs, run:"
            echo "  terraform output"
        else
            echo "Operation cancelled"
        fi
        ;;
    4)
        echo ""
        echo "Current infrastructure state:"
        terraform show
        ;;
    5)
        echo ""
        echo -e "${RED}WARNING: This will destroy all infrastructure!${NC}"
        read -p "Are you absolutely sure? Type 'destroy' to confirm: " confirm
        if [ "$confirm" = "destroy" ]; then
            if [ -n "$VAR_FILE" ]; then
                terraform destroy -var-file="$VAR_FILE"
            else
                terraform destroy
            fi
            echo -e "${GREEN}✓ Infrastructure destroyed${NC}"
        else
            echo "Operation cancelled"
        fi
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo "================================================"
echo "  Next Steps"
echo "================================================"
echo ""
echo "For more information, see:"
echo "  • README.md - Complete documentation"
echo "  • modules/*/README.md - Module-specific docs"
echo "  • examples/ - Usage examples"
echo ""
