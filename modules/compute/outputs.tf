#compute outputs.tf

output "private_asg" {
  value = aws_autoscaling_group.private_asg
}