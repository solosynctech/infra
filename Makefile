.PHONY: help init plan apply destroy fmt validate clean dev staging prod

# Default target
help:
	@echo "Attach AI Infrastructure - Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  help       - Show this help message"
	@echo "  init       - Initialize Terraform"
	@echo "  fmt        - Format Terraform files"
	@echo "  validate   - Validate Terraform configuration"
	@echo "  plan       - Show Terraform plan"
	@echo "  apply      - Apply Terraform changes"
	@echo "  destroy    - Destroy all infrastructure"
	@echo "  clean      - Clean Terraform cache and lock files"
	@echo ""
	@echo "Environment-specific targets:"
	@echo "  dev        - Plan for development environment"
	@echo "  dev-apply  - Apply development environment"
	@echo "  staging    - Plan for staging environment"
	@echo "  staging-apply - Apply staging environment"
	@echo "  prod       - Plan for production environment"
	@echo "  prod-apply - Apply production environment"
	@echo ""
	@echo "Usage examples:"
	@echo "  make init"
	@echo "  make dev"
	@echo "  make dev-apply"

# Initialize Terraform
init:
	terraform init

# Format Terraform files
fmt:
	terraform fmt -recursive

# Validate Terraform configuration
validate:
	terraform validate

# Show Terraform plan
plan:
	terraform plan

# Apply Terraform changes
apply:
	terraform apply

# Destroy all infrastructure
destroy:
	terraform destroy

# Clean Terraform cache
clean:
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate*
	find . -type f -name ".terraform.lock.hcl" -delete
	find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true

# Development environment
dev:
	terraform plan -var-file=environments/dev/terraform.tfvars

dev-apply:
	terraform apply -var-file=environments/dev/terraform.tfvars

dev-destroy:
	terraform destroy -var-file=environments/dev/terraform.tfvars

# Staging environment
staging:
	terraform plan -var-file=environments/staging/terraform.tfvars

staging-apply:
	terraform apply -var-file=environments/staging/terraform.tfvars

staging-destroy:
	terraform destroy -var-file=environments/staging/terraform.tfvars

# Production environment
prod:
	terraform plan -var-file=environments/prod/terraform.tfvars

prod-apply:
	@echo "WARNING: This will apply changes to PRODUCTION!"
	@read -p "Are you sure? (yes/no): " answer; \
	if [ "$$answer" = "yes" ]; then \
		terraform apply -var-file=environments/prod/terraform.tfvars; \
	else \
		echo "Cancelled."; \
	fi

prod-destroy:
	@echo "WARNING: This will DESTROY PRODUCTION infrastructure!"
	@read -p "Type 'destroy-production' to confirm: " answer; \
	if [ "$$answer" = "destroy-production" ]; then \
		terraform destroy -var-file=environments/prod/terraform.tfvars; \
	else \
		echo "Cancelled."; \
	fi
