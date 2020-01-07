# core/ecs-autoscaling-target

A Terraform module to define AWS ECS Service Auto Scaling Target

Autoscaling Target required by application autoscaling policy and there should be only **ONE** instance of this per ECS Service.

Each other ECS Service should have this module.

One `ecs_target` per `ECS Service` or else terraform will fail.

## Components

Creates the following:
- ECS Application Autoscaling Target

## Assumptions

- ECS Cluster made by main module (HENNGE/terraform-aws-ecs)
- Service is also by `core/service` or `simple/*`


## Example

Hardcoded:
```hcl
module "ecs_service_scaling_target" {
  source           = "HENNGE/ecs/aws//modules/core/ecs-autoscaling-target"
  version          = "1.0.0"

  ecs_cluster_name = "ecs-cluster-something"
  ecs_service_name = "the-ecs-service"
  min_capacity     = 5
  max_capacity     = 10
}
```


Values obtained from other module (e.g. application stack),
Make sure to output the values so it can be referred.
```hcl
module "ecs_service_scaling_target" {
  source           = "HENNGE/ecs/aws//modules/core/ecs-autoscaling-target"
  version          = "1.0.0"

  ecs_cluster_name = module.application_stack.ecs_cluster_name
  ecs_service_name = module.application_stack.ecs_service_name
  min_capacity     = module.application_stack.ecs_service_desired_count
  max_capacity     = module.application_stack.ecs_service_desired_count * 2
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ecs\_cluster\_name | ECS Cluster name to apply on \(NOT ARN\) | string | n/a | yes |
| ecs\_service\_name | ECS Service name to apply on \(NOT ARN\) | string | n/a | yes |
| max\_capacity | Maximum capacity of ECS autoscaling target, cannot be less than min\_capacity | number | n/a | yes |
| min\_capacity | Minimum capacity of ECS autoscaling target, cannot be more than max\_capacity | number | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| max\_capacity | Maximum capacity for autoscaling target, same value as inputted |
| min\_capacity | Minimum capacity for autoscaling target, same value as inputted |
| resource\_id | Resources ID of the created Autoscaling Target for ECS Service, used in policy/schedule |
| scalable\_dimension | Scalable dimension for autoscaling target. Always ecs:service:DesiredCount. |
| service\_namespace | Service namespace for autoscaling target. Always ecs |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


