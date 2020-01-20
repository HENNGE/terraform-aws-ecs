# autoscaling/ecs-target-tracking/service-utilization

A Terraform module to define AWS ECS Service Auto Scaling based on, `AverageCPUUtilization` and/or `AverageMemoryUtilization` metrics.

## Components

Creates the following:
- ECS Application Autoscaling Policy

Autocreated by aws:
- Cloudwatch alarms for tracking service utilization metrics

## Assumptions

- ECS Cluster made by `HENNGE/ecs/aws`
- Service is also by `HENNGE/ecs/aws//modules/core/service` or `HENNGE/ecs/aws//modules/simple/*`
- ECS Autoscaling Target is made by `HENNGE/ecs/aws//modules/core/ecs-autoscaling-target`
- ECS Cluster EC2 Instances are not running on full capacity (remaining capacity is sufficient to start new tasks)


## Example

Hardcoded:
```hcl
module "ecs_service_scaling" {
  source  = "HENNGE/ecs/aws//modules/autoscaling/ecs-target-tracking/service-utilization"
  version = "1.0.0"

  name                        = "${local.prefix}-ecs-utilization"
  scalable_target_resource_id = "service/ecs-cluster-something/the-ecs-service"

  enable_cpu_based_autoscaling = true
  target_cpu_value             = 50
}
```


Values obtained from other module (e.g. application stack),
Make sure to output the values so it can be referred.
```hcl
module "ecs_service_scaling" {
  source  = "HENNGE/ecs/aws//modules/autoscaling/ecs-target-tracking/service-utilization"
  version = "1.0.0"

  name                        = "${local.prefix}-ecs-utilization"
  scalable_target_resource_id = module.ecs_service_scaling_target.resource_id

  enable_cpu_based_autoscaling = true
  target_cpu_value             = 50
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| disable\_scale\_in | Disable scale-in action, defaults to false | bool | `"false"` | no |
| enable\_cpu\_based\_autoscaling | Enable Autoscaling based on ECS Service CPU Usage | bool | `"false"` | no |
| enable\_memory\_based\_autoscaling | Enable Autoscaling based on ECS Service Memory Usage | bool | `"false"` | no |
| name | Name of the ECS Policy created, will appear in Auto Scaling under Service in ECS | string | n/a | yes |
| scalable\_target\_resource\_id | Scalable target resource id, either from resource `aws\_appautoscaling\_target` or from `core/ecs-autoscaling-target` module | string | n/a | yes |
| scale\_in\_cooldown | Time between scale in action | number | `"300"` | no |
| scale\_out\_cooldown | Time between scale out action | number | `"300"` | no |
| target\_cpu\_value | Autoscale when CPU Usage value over the specified value. Must be specified if `enable\_cpu\_based\_autoscaling` is `true`. | number | `"null"` | no |
| target\_memory\_value | Autoscale when Memory Usage value over the specified value. Must be specified if `enable\_memory\_based\_autoscaling` is `true`. | number | `"null"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cpu\_policy\_arn | ARN of the autoscaling policy generated. |
| cpu\_policy\_name | Name of the autoscaling policy generated |
| cpu\_policy\_type | Policy type of the autoscaling policy generated. Always TargetTrackingScaling |
| memory\_policy\_arn | ARN of the autoscaling policy generated. |
| memory\_policy\_name | Name of the autoscaling policy generated |
| memory\_policy\_type | Policy type of the autoscaling policy generated. Always TargetTrackingScaling |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
