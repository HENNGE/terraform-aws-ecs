output "load_balancer_dns" {
  description = "Accessible load balancer DNS"
  value       = module.alb.this_lb_dns_name
}
