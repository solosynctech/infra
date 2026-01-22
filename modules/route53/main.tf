# Route53 Module
# Creates and manages Route53 hosted zones and DNS records

# Hosted Zone
resource "aws_route53_zone" "main" {
  count = var.create_zone ? 1 : 0
  name  = var.domain_name

  vpc {
    vpc_id = var.vpc_id
  }

  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    {
      Name = var.domain_name
    }
  )
}

# Data source for existing hosted zone (if not creating new)
data "aws_route53_zone" "existing" {
  count        = var.create_zone ? 0 : 1
  name         = var.domain_name
  private_zone = var.private_zone
}

locals {
  zone_id = var.create_zone ? aws_route53_zone.main[0].zone_id : data.aws_route53_zone.existing[0].zone_id
}

# A Records
resource "aws_route53_record" "a_records" {
  for_each = var.a_records

  zone_id = local.zone_id
  name    = each.key
  type    = "A"
  ttl     = each.value.ttl
  records = each.value.records
}

# CNAME Records
resource "aws_route53_record" "cname_records" {
  for_each = var.cname_records

  zone_id = local.zone_id
  name    = each.key
  type    = "CNAME"
  ttl     = each.value.ttl
  records = [each.value.record]
}

# Alias Records
resource "aws_route53_record" "alias_records" {
  for_each = var.alias_records

  zone_id = local.zone_id
  name    = each.key
  type    = each.value.type

  alias {
    name                   = each.value.target_dns_name
    zone_id                = each.value.target_zone_id
    evaluate_target_health = each.value.evaluate_target_health
  }
}

# MX Records
resource "aws_route53_record" "mx_records" {
  for_each = var.mx_records

  zone_id = local.zone_id
  name    = each.key
  type    = "MX"
  ttl     = each.value.ttl
  records = each.value.records
}

# TXT Records
resource "aws_route53_record" "txt_records" {
  for_each = var.txt_records

  zone_id = local.zone_id
  name    = each.key
  type    = "TXT"
  ttl     = each.value.ttl
  records = each.value.records
}
