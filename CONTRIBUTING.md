# Contributing to Attach AI Infrastructure

Thank you for your interest in contributing to this infrastructure repository!

## Getting Started

1. **Fork the repository**
2. **Clone your fork:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/infra.git
   cd infra
   ```
3. **Create a branch:**
   ```bash
   git checkout -b feature/my-feature
   ```

## Development Guidelines

### Terraform Best Practices

1. **Use consistent formatting:**
   ```bash
   terraform fmt -recursive
   ```

2. **Validate your changes:**
   ```bash
   terraform validate
   ```

3. **Test in a dev environment first:**
   - Never test directly in production
   - Use environment-specific variable files

4. **Keep modules focused:**
   - Each module should have a single responsibility
   - Modules should be reusable across environments

### Module Structure

Each module should include:
- `main.tf` - Main resource definitions
- `variables.tf` - Input variable definitions
- `outputs.tf` - Output value definitions
- `README.md` - Module documentation

### Documentation

1. **Update README files:**
   - Add examples for new features
   - Document all variables and outputs
   - Include usage examples

2. **Use descriptive variable names:**
   ```hcl
   # Good
   variable "enable_nat_gateway" {
     description = "Enable NAT Gateway for private subnets"
     type        = bool
   }
   
   # Bad
   variable "nat" {
     type = bool
   }
   ```

3. **Add comments for complex logic:**
   ```hcl
   # Create NAT gateway only if enabled and based on single/multi config
   resource "aws_nat_gateway" "main" {
     count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnet_cidrs)) : 0
     # ...
   }
   ```

### Security

1. **Never commit sensitive data:**
   - No AWS credentials
   - No private keys
   - No passwords or secrets
   - Use `.gitignore` properly

2. **Use secure defaults:**
   - Enable encryption by default
   - Use private subnets for workloads
   - Minimize public access

3. **Follow least privilege:**
   - IAM roles should have minimal permissions
   - Security groups should be restrictive

### Testing

Before submitting a PR:

1. **Format your code:**
   ```bash
   terraform fmt -recursive
   ```

2. **Validate syntax:**
   ```bash
   terraform validate
   ```

3. **Run a plan:**
   ```bash
   terraform plan -var-file=environments/dev/terraform.tfvars
   ```

4. **Test in dev environment:**
   ```bash
   terraform apply -var-file=environments/dev/terraform.tfvars
   ```

5. **Verify outputs:**
   ```bash
   terraform output
   ```

6. **Clean up:**
   ```bash
   terraform destroy -var-file=environments/dev/terraform.tfvars
   ```

## Pull Request Process

1. **Update documentation:**
   - Update README if adding features
   - Update module documentation
   - Add examples if applicable

2. **Create a clear PR description:**
   - What does this PR do?
   - Why is this change needed?
   - How was it tested?
   - Any breaking changes?

3. **Link related issues:**
   - Reference issue numbers
   - Use GitHub keywords (fixes #123)

4. **Request review:**
   - Wait for approval before merging
   - Address review comments

## Code Review Guidelines

As a reviewer:

1. **Check for:**
   - Terraform best practices
   - Security implications
   - Cost implications
   - Breaking changes
   - Documentation completeness

2. **Test the changes:**
   - Run `terraform plan`
   - Verify outputs make sense

3. **Provide constructive feedback:**
   - Be specific about concerns
   - Suggest improvements
   - Explain reasoning

## Commit Messages

Use clear, descriptive commit messages:

```
# Good
feat: Add support for multiple NAT gateways in VPC module
fix: Correct EKS node group scaling configuration
docs: Update Lambda module README with Python example

# Bad
update
fix bug
changes
```

Format: `type: description`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

## Versioning

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

## Questions?

- Open an issue for discussions
- Tag maintainers for urgent matters
- Check existing issues and PRs first

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.
