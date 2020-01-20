resource "aws_autoscaling_policy" "cpu_autoscaling" {
  count                  = var.enable_cpu_based_autoscaling ? 1 : 0
  name                   = "${var.name}-cpu"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = var.autoscaling_group_name

  target_tracking_configuration {
    target_value     = var.cpu_threshold
    disable_scale_in = var.disable_scale_in

    customized_metric_specification {
      metric_name = "CPUReservation"
      namespace   = "AWS/ECS"
      statistic   = var.cpu_statistics

      metric_dimension {
        name  = "ClusterName"
        value = var.ecs_cluster_name
      }
    }
  }
}

resource "aws_autoscaling_policy" "memory_autoscaling" {
  count                  = var.enable_memory_based_autoscaling ? 1 : 0
  name                   = "${var.name}-memory"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = var.autoscaling_group_name

  target_tracking_configuration {
    target_value     = var.memory_threshold
    disable_scale_in = var.disable_scale_in

    customized_metric_specification {
      metric_name = "MemoryReservation"
      namespace   = "AWS/ECS"
      statistic   = var.memory_statistics

      metric_dimension {
        name  = "ClusterName"
        value = var.ecs_cluster_name
      }
    }
  }
}
