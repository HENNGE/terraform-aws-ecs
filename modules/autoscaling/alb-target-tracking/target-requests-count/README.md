# autoscaling/alb-target-tracking/target-requests-count

A Terraform module to define AWS ECS Service Auto Scaling ALB Target Tracking Policy, `RequestCountPerTarget` metrics.

This autoscaling policy will make ECS automatically adjusts desired count to keep the specified request count per target.

## Components

Creates the following:
- ECS Application Autoscaling Policy

Autocreated by aws:
- Cloudwatch alarms for tracking requests in ALB Target Group

## Assumptions

- ECS Cluster made by `HENNGE/ecs/aws`
- Service is also by `HENNGE/ecs/aws//modules/core/service` or `HENNGE/ecs/aws//modules/simple/*`
- ECS Autoscaling Target is made by `HENNGE/ecs/aws//modules/core/ecs-autoscaling-target`
- ECS Cluster EC2 Instances are not running on full capacity (remaining capacity is sufficient to start new tasks)


## Example

Hardcoded:
```hcl
module "ecs_service_scaling" {
  source  = "HENNGE/ecs/aws//modules/autoscaling/alb-target-tracking/target-requests-count"
  version = "1.0.0"

  name                        = "${local.prefix}-ecs-requestcount"
  alb_arn_suffix              = "loadbalancer/app/inazuma-external-alb/0123456789abcdef"
  target_group_arn_suffix     = "targetgroup/inazuma-g-push/fedcba9876543210"
  scalable_target_resource_id = "service/ecs-cluster-something/the-ecs-service"
  target_value                = 300
  scale_in_cooldown           = 30
  scale_out_cooldown          = 30
  disable_scale_in            = false
}
```


Values obtained from other module (e.g. application stack),
Make sure to output the values so it can be referred.
```hcl
module "ecs_service_scaling" {
  source  = "HENNGE/ecs/aws//modules/autoscaling/alb-target-tracking/target-requests-count"
  version = "1.0.0"

  name                        = "${local.prefix}-ecs-requestcount"
  alb_arn_suffix              = module.application_stack.alb_arn_suffix
  target_group_arn_suffix     = module.application_stack.google_push_alb_target_group_arn_suffix
  scalable_target_resource_id = module.ecs_service_scaling_target.resource_id
  target_value                = 300
  scale_in_cooldown           = 30
  scale_out_cooldown          = 30
  disable_scale_in            = false
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | >= 3.35.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.35.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_arn\_suffix | ARN Suffix (not full ARN) of the Application Load Balancer for use with CloudWatch. Output attribute from LB resource: `arn_suffix` | `string` | n/a | yes |
| disable\_scale\_in | Disable scale-in action, defaults to false | `bool` | `false` | no |
| name | Name of the ECS Policy created, will appear in Auto Scaling under Service in ECS | `string` | n/a | yes |
| scalable\_target\_resource\_id | Scalable target resource id, either from resource `aws_appautoscaling_target` or from `core/ecs-autoscaling-target` module | `string` | n/a | yes |
| scale\_in\_cooldown | Time between scale in action | `number` | `300` | no |
| scale\_out\_cooldown | Time between scale out action | `number` | `300` | no |
| target\_group\_arn\_suffix | ALB Target Group ARN Suffix (not full ARN) for use with CloudWatch. Output attribute from Target Group resource: `arn_suffix` | `string` | n/a | yes |
| target\_value | Requests per target in target group metrics to trigger scaling activity | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the autoscaling policy generated. |
| name | Name of the autoscaling policy generated |
| policy\_type | Policy type of the autoscaling policy generated. Always TargetTrackingScaling |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Things to note

Make sure there's enough capacity left in ECS Cluster EC2 instances (applies for ECS EC2 launch type)
