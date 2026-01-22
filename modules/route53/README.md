# Route53 Module

This module manages AWS Route53 hosted zones and DNS records.

## Features

- Create new hosted zones or use existing ones
- Support for private and public hosted zones
- Multiple record types: A, CNAME, Alias, MX, TXT
- VPC association for private zones
- Flexible record management

## Usage

### Creating a new public hosted zone with records

```hcl
module "route53" {
  source = "./modules/route53"

  domain_name = "example.com"
  create_zone = true
  
  a_records = {
    "www" = {
      ttl     = 300
      records = ["192.0.2.1"]
    }
  }
  
  cname_records = {
    "blog" = {
      ttl    = 300
      record = "www.example.com"
    }
  }
  
  tags = {
    Environment = "production"
  }
}
```

### Using an existing zone

```hcl
module "route53" {
  source = "./modules/route53"

  domain_name  = "example.com"
  create_zone  = false
  private_zone = false
  
  a_records = {
    "api" = {
      ttl     = 300
      records = ["192.0.2.2"]
    }
  }
}
```

### Private hosted zone with VPC

```hcl
module "route53" {
  source = "./modules/route53"

  domain_name  = "internal.example.com"
  create_zone  = true
  private_zone = true
  vpc_id       = module.vpc.vpc_id
  
  a_records = {
    "db" = {
      ttl     = 300
      records = ["10.0.1.10"]
    }
  }
  
  tags = {
    Environment = "dev"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain_name | The domain name for the hosted zone | `string` | n/a | yes |
| create_zone | Whether to create a new hosted zone | `bool` | `true` | no |
| vpc_id | VPC ID to associate with private hosted zone | `string` | `null` | no |
| private_zone | Whether this is a private hosted zone | `bool` | `false` | no |
| force_destroy | Whether to destroy all records when deleting | `bool` | `false` | no |
| a_records | Map of A records to create | `map(object)` | `{}` | no |
| cname_records | Map of CNAME records to create | `map(object)` | `{}` | no |
| alias_records | Map of alias records to create | `map(object)` | `{}` | no |
| mx_records | Map of MX records to create | `map(object)` | `{}` | no |
| txt_records | Map of TXT records to create | `map(object)` | `{}` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| zone_id | The hosted zone ID |
| name_servers | A list of name servers in delegation set |
| zone_arn | The ARN of the Hosted Zone |
| a_record_names | List of A record names |
| cname_record_names | List of CNAME record names |
| alias_record_names | List of alias record names |
