output "zone_id" {
  description = "The hosted zone ID"
  value       = local.zone_id
}

output "name_servers" {
  description = "A list of name servers in associated (or default) delegation set"
  value       = var.create_zone ? aws_route53_zone.main[0].name_servers : []
}

output "zone_arn" {
  description = "The Amazon Resource Name (ARN) of the Hosted Zone"
  value       = var.create_zone ? aws_route53_zone.main[0].arn : data.aws_route53_zone.existing[0].arn
}

output "a_record_names" {
  description = "List of A record names"
  value       = [for record in aws_route53_record.a_records : record.name]
}

output "cname_record_names" {
  description = "List of CNAME record names"
  value       = [for record in aws_route53_record.cname_records : record.name]
}

output "alias_record_names" {
  description = "List of alias record names"
  value       = [for record in aws_route53_record.alias_records : record.name]
}
