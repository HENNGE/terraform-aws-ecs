# autoscaling/alb-target-tracking/target-response-time

A Terraform module to define AWS ECS Service Auto Scaling ALB Target Tracking Policy, `TargetResponseTime` metrics.

This autoscaling policy will make ECS automatically adjusts desired count to keep the specified target response time (from Target Group's metric).


## Components

Creates the following:
- ECS Application Autoscaling Policy

Autocreated by aws:
- Cloudwatch alarms for tracking target response time in ALB Target Group

## Assumptions

- ECS Cluster made by `HENNGE/ecs/aws`
- Service is also by `HENNGE/ecs/aws//modules/core/service` or `HENNGE/ecs/aws//modules/simple/*`
- ECS Autoscaling Target is made by `HENNGE/ecs/aws//modules/core/ecs-autoscaling-target`
- ECS Cluster EC2 Instances are not running on full capacity (remaining capacity is sufficient to start new tasks)


## Example

Hardcoded:
```hcl
module "ecs_service_scaling" {
  source  = "HENNGE/ecs/aws//modules/autoscaling/alb-target-tracking/target-response-time"
  version = "1.0.0"

  name                        = "${local.prefix}-ecs-response"
  alb_arn_suffix              = "loadbalancer/app/inazuma-external-alb/0123456789abcdef"
  target_group_arn_suffix     = "targetgroup/inazuma-g-push/fedcba9876543210"
  scalable_target_resource_id = "service/ecs-cluster-something/the-ecs-service"
  target_value                = 1
  scale_in_cooldown           = 30
  scale_out_cooldown          = 30
  disable_scale_in            = false
}
```


Values obtained from other module (e.g. application stack),
Make sure to output the values so it can be referred.
```hcl
module "ecs_service_scaling" {
  source  = "HENNGE/ecs/aws//modules/autoscaling/alb-target-tracking/target-response-time"
  version = "1.0.0"

  name                        = "${local.prefix}-ecs-response"
  alb_arn_suffix              = module.application_stack.alb_arn_suffix
  target_group_arn_suffix     = module.application_stack.google_push_alb_target_group_arn_suffix
  scalable_target_resource_id = module.ecs_service_scaling_target.resource_id
  target_value                = 1
  scale_in_cooldown           = 30
  scale_out_cooldown          = 30
  disable_scale_in            = false
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.85.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.85.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.ecs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_arn_suffix"></a> [alb\_arn\_suffix](#input\_alb\_arn\_suffix) | ARN Suffix (not full ARN) of the Application Load Balancer for use with CloudWatch. Output attribute from LB resource: `arn_suffix` | `string` | n/a | yes |
| <a name="input_disable_scale_in"></a> [disable\_scale\_in](#input\_disable\_scale\_in) | Disable scale-in action, defaults to false | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the ECS Policy created, will appear in Auto Scaling under Service in ECS | `string` | n/a | yes |
| <a name="input_scalable_target_resource_id"></a> [scalable\_target\_resource\_id](#input\_scalable\_target\_resource\_id) | Scalable target resource id, either from resource `aws_appautoscaling_target` or from `core/ecs-autoscaling-target` module | `string` | n/a | yes |
| <a name="input_scale_in_cooldown"></a> [scale\_in\_cooldown](#input\_scale\_in\_cooldown) | Time between scale in action | `number` | `300` | no |
| <a name="input_scale_out_cooldown"></a> [scale\_out\_cooldown](#input\_scale\_out\_cooldown) | Time between scale out action | `number` | `300` | no |
| <a name="input_statistic"></a> [statistic](#input\_statistic) | Statistic to use. Valid value one of [Average, Minimum, Maximum, SampleCount, Sum] | `string` | `"Average"` | no |
| <a name="input_target_group_arn_suffix"></a> [target\_group\_arn\_suffix](#input\_target\_group\_arn\_suffix) | ALB Target Group ARN Suffix (not full ARN) for use with CloudWatch. Output attribute from Target Group resource: `arn_suffix` | `string` | n/a | yes |
| <a name="input_target_value"></a> [target\_value](#input\_target\_value) | Response time per target in target group metrics to trigger scaling activity (in seconds) | `number` | n/a | yes |
| <a name="input_units"></a> [units](#input\_units) | Units to use in monitoring, valid values are [Seconds, Microseconds, Milliseconds] | `string` | `"Seconds"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the autoscaling policy generated. |
| <a name="output_name"></a> [name](#output\_name) | Name of the autoscaling policy generated |
| <a name="output_policy_type"></a> [policy\_type](#output\_policy\_type) | Policy type of the autoscaling policy generated. Always TargetTrackingScaling |
<!-- END_TF_DOCS -->


## Things to note

Make sure there's enough capacity left in ECS Cluster EC2 instances (applies for ECS EC2 launch type)
