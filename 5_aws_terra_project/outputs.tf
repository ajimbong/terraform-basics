##
# Log the dns name of the ALB

output "alb-dns-name" {
  value = aws_lb.alb.dns_name
}

output "route-53-domain" {
  value = aws_route53_record.site_domain.name
}