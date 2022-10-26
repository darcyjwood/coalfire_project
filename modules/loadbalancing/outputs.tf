#loadbalancing outputs.tf

output "elb" {
  value = aws_lb.cf_lb.id
}

output "lb_tg" {
  value = aws_lb_target_group.cf_tg.arn
}

output "lb_dns" {
  value = aws_lb.cf_lb.dns_name
}