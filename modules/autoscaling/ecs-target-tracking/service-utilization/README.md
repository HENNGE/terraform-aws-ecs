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
| [aws_appautoscaling_policy.ecs_service_cpu_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.ecs_service_memory_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_disable_scale_in"></a> [disable\_scale\_in](#input\_disable\_scale\_in) | Disable scale-in action, defaults to false | `bool` | `false` | no |
| <a name="input_enable_cpu_based_autoscaling"></a> [enable\_cpu\_based\_autoscaling](#input\_enable\_cpu\_based\_autoscaling) | Enable Autoscaling based on ECS Service CPU Usage | `bool` | `false` | no |
| <a name="input_enable_memory_based_autoscaling"></a> [enable\_memory\_based\_autoscaling](#input\_enable\_memory\_based\_autoscaling) | Enable Autoscaling based on ECS Service Memory Usage | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the ECS Policy created, will appear in Auto Scaling under Service in ECS | `string` | n/a | yes |
| <a name="input_scalable_target_resource_id"></a> [scalable\_target\_resource\_id](#input\_scalable\_target\_resource\_id) | Scalable target resource id, either from resource `aws_appautoscaling_target` or from `core/ecs-autoscaling-target` module | `string` | n/a | yes |
| <a name="input_scale_in_cooldown"></a> [scale\_in\_cooldown](#input\_scale\_in\_cooldown) | Time between scale in action | `number` | `300` | no |
| <a name="input_scale_out_cooldown"></a> [scale\_out\_cooldown](#input\_scale\_out\_cooldown) | Time between scale out action | `number` | `300` | no |
| <a name="input_target_cpu_value"></a> [target\_cpu\_value](#input\_target\_cpu\_value) | Autoscale when CPU Usage value over the specified value. Must be specified if `enable_cpu_based_autoscaling` is `true`. | `number` | `null` | no |
| <a name="input_target_memory_value"></a> [target\_memory\_value](#input\_target\_memory\_value) | Autoscale when Memory Usage value over the specified value. Must be specified if `enable_memory_based_autoscaling` is `true`. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cpu_policy_arn"></a> [cpu\_policy\_arn](#output\_cpu\_policy\_arn) | ARN of the autoscaling policy generated. |
| <a name="output_cpu_policy_name"></a> [cpu\_policy\_name](#output\_cpu\_policy\_name) | Name of the autoscaling policy generated |
| <a name="output_cpu_policy_type"></a> [cpu\_policy\_type](#output\_cpu\_policy\_type) | Policy type of the autoscaling policy generated. Always TargetTrackingScaling |
| <a name="output_memory_policy_arn"></a> [memory\_policy\_arn](#output\_memory\_policy\_arn) | ARN of the autoscaling policy generated. |
| <a name="output_memory_policy_name"></a> [memory\_policy\_name](#output\_memory\_policy\_name) | Name of the autoscaling policy generated |
| <a name="output_memory_policy_type"></a> [memory\_policy\_type](#output\_memory\_policy\_type) | Policy type of the autoscaling policy generated. Always TargetTrackingScaling |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
