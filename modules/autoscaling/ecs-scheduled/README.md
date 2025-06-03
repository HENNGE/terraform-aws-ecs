# autoscaling/ecs-scheduled

A Terraform module to define AWS ECS Service Auto Scaling scheduled action.

## Components

Creates the following:
- ECS Application Autoscaling Scheduled Action

## Assumptions

- ECS Cluster made by `HENNGE/ecs/aws`
- Service is also by `HENNGE/ecs/aws//modules/core/service` or `HENNGE/ecs/aws//modules/simple/*`
- ECS Autoscaling Target is made by `HENNGE/ecs/aws//modules/core/ecs-autoscaling-target` or `aws_appautoscaling_target`
- ECS Cluster EC2 Instances are not running on full capacity (remaining capacity is sufficient to start new tasks)


## Example

Values obtained from other module (e.g. application stack).
Make sure to output the values so it can be referred.
```hcl
module "ecs_scaling_scheduled" {
  source  = "HENNGE/ecs/aws//modules/autoscaling/ecs-scheduled"
  version = "~> 2.0"

  name                        = "${local.prefix}-ecs-scaling_scheduled"
  scalable_target_resource_id = module.ecs_service_scaling_target.resource_id

  schedule = "at(2021-01-31T17:00:00)"
  timezone = "Asia/Tokyo"

  min_capacity = 1
  max_capacity = 3
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
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
| [aws_appautoscaling_scheduled_action.ecs_scheduled_action](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_scheduled_action) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Maximum capacity. At least one of max\_capacity or min\_capacity must be set. | `string` | `null` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimum capacity. At least one of max\_capacity or min\_capacity must be set. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the autoscaling scheduled action, will appear in Auto Scaling under Service in ECS | `string` | n/a | yes |
| <a name="input_scalable_target_resource_id"></a> [scalable\_target\_resource\_id](#input\_scalable\_target\_resource\_id) | Scalable target resource id, either from resource `aws_appautoscaling_target` or from `core/ecs-autoscaling-target` module | `string` | n/a | yes |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | Schedule expression. See https://docs.aws.amazon.com/autoscaling/application/APIReference/API_PutScheduledAction.html#autoscaling-PutScheduledAction-request-Schedule | `string` | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Time zone used when setting a scheduled action by using an at or cron expression. For valid values see https://www.joda.org/joda-time/timezones.html | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_scheduled_action_arn"></a> [scheduled\_action\_arn](#output\_scheduled\_action\_arn) | ARN of the autoscaling scheduled action. |
<!-- END_TF_DOCS -->
