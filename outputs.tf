#root outputs.tf

output "lb_dns" {
  value = module.loadbalancing.lb_dns
}