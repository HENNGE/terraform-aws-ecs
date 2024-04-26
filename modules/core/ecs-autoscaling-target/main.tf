resource "aws_appautoscaling_target" "ecs_target" {
  count = var.ignore_capacity_changes ? 0 : 1

  # Workaround for https://github.com/hashicorp/terraform-provider-aws/issues/31261
  lifecycle {
    ignore_changes = [tags_all]
  }

  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_target" "ecs_target_ignore_capacity_changes" {
  count = var.ignore_capacity_changes ? 1 : 0

  # Workaround for https://github.com/hashicorp/terraform-provider-aws/issues/31261
  lifecycle {
    ignore_changes = [min_capacity, max_capacity, tags_all]
  }

  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
