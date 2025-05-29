# core/ecs-autoscaling-target

A Terraform module to define AWS ECS Service Auto Scaling Target

Autoscaling Target required by application autoscaling policy and there should be only **ONE** instance of this per ECS Service.

Each other ECS Service should have this module.

One `ecs_target` per `ECS Service` or else terraform will fail.

## Components

Creates the following:
- ECS Application Autoscaling Target

## Assumptions

- ECS Cluster made by `HENNGE/ecs/aws`
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
| [aws_appautoscaling_target.ecs_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appautoscaling_target.ecs_target_ignore_capacity_changes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | ECS Cluster name to apply on (NOT ARN) | `string` | n/a | yes |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | ECS Service name to apply on (NOT ARN) | `string` | n/a | yes |
| <a name="input_ignore_capacity_changes"></a> [ignore\_capacity\_changes](#input\_ignore\_capacity\_changes) | Ignores any changes to `min_capacity` and `max_capacity` parameter after apply. Note updating this value will destroy the existing autoscaling target and recreate it. | `bool` | `false` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Maximum capacity of ECS autoscaling target, cannot be less than min\_capacity | `number` | n/a | yes |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimum capacity of ECS autoscaling target, cannot be more than max\_capacity | `number` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | ARN of the IAM role that allows Application AutoScaling to modify your scalable target on your behalf. This defaults to an IAM Service-Linked Role for most services and custom IAM Roles are ignored by the API for those namespaces. | `string` | `null` | no |
| <a name="input_suspended_state"></a> [suspended\_state](#input\_suspended\_state) | Specifies whether the scaling activities for a scalable target are in a suspended state. | <pre>object({<br>    dynamic_scaling_in_suspended  = bool<br>    dynamic_scaling_out_suspended = bool<br>    scheduled_scaling_suspended   = bool<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_max_capacity"></a> [max\_capacity](#output\_max\_capacity) | Maximum capacity for autoscaling target, same value as inputted |
| <a name="output_min_capacity"></a> [min\_capacity](#output\_min\_capacity) | Minimum capacity for autoscaling target, same value as inputted |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | Resources ID of the created Autoscaling Target for ECS Service, used in policy/schedule |
| <a name="output_scalable_dimension"></a> [scalable\_dimension](#output\_scalable\_dimension) | Scalable dimension for autoscaling target. Always ecs:service:DesiredCount. |
| <a name="output_service_namespace"></a> [service\_namespace](#output\_service\_namespace) | Service namespace for autoscaling target. Always ecs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
