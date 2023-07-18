##
# Log the dns name of the ALB

output "alb-dns-name" {
  value = aws_lb.alb.dns_name
}