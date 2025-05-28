terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.85.0"
    }
  }
}

resource "aws_ecs_cluster" "test" {
  name = "test-cluster"
}

module "ecs_service" {
  source                        = "../modules/core/service"
  name                          = "test"
  cluster                       = aws_ecs_cluster.test.name
  create_task_definition        = true
  availability_zone_rebalancing = "ENABLED"
  task_track_latest             = true

  container_definitions = jsonencode(
    [
      {
        name  = "app"
        image = ":latest"

        cpu          = 256
        memory       = 512
        architecture = "ARM64"
        essential    = true

        environment = [
          {
            name  = "CONFIG_PATH"
            value = "foo"
          },
        ]

        portMappings = [
          {
            containerPort = 12121,
            trafficPort   = 12121
          },
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "/ecs/-service"
            awslogs-region        = "bar"
            awslogs-stream-prefix = "ecs"
          }
        }
      }
    ]
  )
}

module "test_scaling" {
  source           = "../modules/core/ecs-autoscaling-target"
  ecs_cluster_name = aws_ecs_cluster.test.name
  min_capacity     = 0
  max_capacity     = 1
  ecs_service_name = module.ecs_service.name
  suspended_state = {
    dynamic_scaling_in_suspended  = true
    dynamic_scaling_out_suspended = false
    scheduled_scaling_suspended   = true
  }
}
