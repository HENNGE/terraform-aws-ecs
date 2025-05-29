resource "aws_appautoscaling_target" "ecs_target" {
  count = var.ignore_capacity_changes ? 0 : 1

  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  role_arn           = var.role_arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  dynamic "suspended_state" {
    for_each = var.suspended_state == null ? [] : [var.suspended_state]

    content {
      dynamic_scaling_in_suspended  = suspended_state.value.dynamic_scaling_in_suspended
      dynamic_scaling_out_suspended = suspended_state.value.dynamic_scaling_out_suspended
      scheduled_scaling_suspended   = suspended_state.value.scheduled_scaling_suspended
    }
  }
}

resource "aws_appautoscaling_target" "ecs_target_ignore_capacity_changes" {
  count = var.ignore_capacity_changes ? 1 : 0

  lifecycle {
    ignore_changes = [min_capacity, max_capacity]
  }

  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  role_arn           = var.role_arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  dynamic "suspended_state" {
    for_each = var.suspended_state == null ? [] : [var.suspended_state]

    content {
      dynamic_scaling_in_suspended  = suspended_state.value.dynamic_scaling_in_suspended
      dynamic_scaling_out_suspended = suspended_state.value.dynamic_scaling_out_suspended
      scheduled_scaling_suspended   = suspended_state.value.scheduled_scaling_suspended
    }
  }
}
