output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.sales.repository_url
}


output "ecs_cluster_name" {
  value = aws_ecs_cluster.sales_cluster.name
}