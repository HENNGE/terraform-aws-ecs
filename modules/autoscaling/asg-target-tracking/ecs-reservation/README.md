# autoscaling/asg-target-tracking/ecs-reservation

A Terraform module to define AWS EC2 Autoscaling Group Auto Scaling Target Tracking Policy

Target-tracking autoscaling policy is similar to those of `DynamoDB autoscaling`.

Note: There's new [`ECS Capacity Provider`](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-auto-scaling.html#asg-capacity-providers) which can manage scaling of autoscaling group by ECS. This module is not it and this module might be made obsolete in the future by that.

## How AWS EC2 Autoscaling Group Auto Scaling Target Tracking Policy Works

It works similar to `DynamoDB Autoscaling`.

First, this will generate a scaling policy attached to EC2 Autoscaling Group (ASG), then it automatically creates CloudWatch alarms to monitor the `CPUReservation` and/or `MemoryReservation` metric in ECS Cluster.

It will create 2 metrics, a scale-out trigger alarm and a scale-in trigger alarm (in case that `disable_scale_in` is set to `false`).
When the `scale-out trigger alarm` triggers (that is `ECS CPU/Memory Reservation` >= `(cpu|memory)_threshold` option for 3 minutes) it will adjust the ASG Instances desired count to bring down the number of `ECS CPU Reservation` to the specified `(cpu|memory)_threshold`.
If the `scale-in` is enabled, then alarm will trigger when `(cpu|memory)_threshold` < (`ECS CPU/Memory Reservation` - `some numbers`(AWS decided)) for 15 minutes it will adjust the ASG Instances desired count to bring up the number of `ECS CPU/Memory Reservation` close to `(cpu|memory)_threshold` but trying not to trigger the scale-out alarm.


What happens if the `scale-in` is enabled and the number of `(cpu|memory)_threshold` is always low and always triggers the scale-in alarm?

The policy will not reduce the number of desired count less than `min_capacity` set in the ASG Definition.
Therefore it's important not to set the `min_capacity` in ASG too low to prevent scale-in action beyond "normal" desired instances count (baseline).


## Components

Creates the following:
- EC2 Autoscaling Group (ASG) Auto Scaling Policy

Autocreated by aws:
- Cloudwatch alarms for tracking ECS reservation (CPU and/or Memory)

## Assumptions

- ECS Cluster made by `HENNGE/ecs/aws`.
- ASG made by `autoscaling` module on registry
- ECS Cluster EC2 Instances are not running on full capacity (remaining capacity is sufficient to start new tasks)
- Scaling interval is set on ASG side (`default_cooldown`)


## Example

Hardcoded:
```hcl
module "asg_scaling" {
  source           = "HENNGE/ecs/aws//modules/autoscaling/asg-target-tracking/ecs-reservation"
  version          = "1.0.0"

  name                         = "${local.prefix}-policy"
  autoscaling_group_name       = "autoscaling-group-name"
  ecs_cluster_name             = "ecs-cluster-name"
  enable_cpu_based_autoscaling = true
  cpu_threshold                = 50
  cpu_statistics               = "Average"
}
```


Values obtained from other module (e.g. application stack),
Make sure to output the values so it can be referred.
```hcl
module "asg_scaling" {
  source           = "HENNGE/ecs/aws//modules/autoscaling/asg-target-tracking/ecs-reservation"
  version          = "1.0.0"

  name                         = "${local.prefix}-policy"
  autoscaling_group_name       = module.application_stack.asg_name
  ecs_cluster_name             = module.application_stack.ecs_cluster_name
  enable_cpu_based_autoscaling = true
  cpu_threshold                = 50
  cpu_statistics               = "Average"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.77.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.77.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_policy.cpu_autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_policy.memory_autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_group_name"></a> [autoscaling\_group\_name](#input\_autoscaling\_group\_name) | Autoscaling Group to apply the policy | `string` | n/a | yes |
| <a name="input_cpu_statistics"></a> [cpu\_statistics](#input\_cpu\_statistics) | Statistics to use: [Maximum, SampleCount, Sum, Minimum, Average]. Note that resolution used in alarm generated is 1 minute. | `string` | `"Average"` | no |
| <a name="input_cpu_threshold"></a> [cpu\_threshold](#input\_cpu\_threshold) | Keep the ECS Cluster CPU Reservation around this value. Value is in percentage (0..100). Must be specified if cpu based autoscaling is enabled. | `number` | `null` | no |
| <a name="input_disable_scale_in"></a> [disable\_scale\_in](#input\_disable\_scale\_in) | Indicates whether scale in by the target tracking policy is disabled. | `bool` | `false` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | Name (not ARN) of ECS Cluster that the autoscaling group is attached to | `string` | n/a | yes |
| <a name="input_enable_cpu_based_autoscaling"></a> [enable\_cpu\_based\_autoscaling](#input\_enable\_cpu\_based\_autoscaling) | Enable Autoscaling based on ECS Cluster CPU Reservation | `bool` | `false` | no |
| <a name="input_enable_memory_based_autoscaling"></a> [enable\_memory\_based\_autoscaling](#input\_enable\_memory\_based\_autoscaling) | Enable Autoscaling based on ECS Cluster Memory Reservation | `bool` | `false` | no |
| <a name="input_memory_statistics"></a> [memory\_statistics](#input\_memory\_statistics) | Statistics to use: [Maximum, SampleCount, Sum, Minimum, Average]. Note that resolution used in alarm generated is 1 minute. | `string` | `"Average"` | no |
| <a name="input_memory_threshold"></a> [memory\_threshold](#input\_memory\_threshold) | Keep the ECS Cluster Memory Reservation around this value. Value is in percentage (0..100). Must be specified if memory based autoscaling is enabled. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix of the Autoscaling Policy | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cpu_autoscaling_arn"></a> [cpu\_autoscaling\_arn](#output\_cpu\_autoscaling\_arn) | The ARN assigned by AWS to the scaling policy. |
| <a name="output_cpu_autoscaling_asg_name"></a> [cpu\_autoscaling\_asg\_name](#output\_cpu\_autoscaling\_asg\_name) | The scaling policy's assigned autoscaling group. |
| <a name="output_cpu_autoscaling_name"></a> [cpu\_autoscaling\_name](#output\_cpu\_autoscaling\_name) | The scaling policy's name. |
| <a name="output_cpu_autoscaling_policy_type"></a> [cpu\_autoscaling\_policy\_type](#output\_cpu\_autoscaling\_policy\_type) | The scaling policy's type. |
| <a name="output_memory_autoscaling_arn"></a> [memory\_autoscaling\_arn](#output\_memory\_autoscaling\_arn) | The ARN assigned by AWS to the scaling policy. |
| <a name="output_memory_autoscaling_asg_name"></a> [memory\_autoscaling\_asg\_name](#output\_memory\_autoscaling\_asg\_name) | The scaling policy's assigned autoscaling group. |
| <a name="output_memory_autoscaling_name"></a> [memory\_autoscaling\_name](#output\_memory\_autoscaling\_name) | The scaling policy's name. |
| <a name="output_memory_autoscaling_policy_type"></a> [memory\_autoscaling\_policy\_type](#output\_memory\_autoscaling\_policy\_type) | The scaling policy's type. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Things to note

Make sure there's enough capacity left in ECS Cluster EC2 instances to allow some room before autoscaling takes place as this might take 3 minutes + some minutes to join ECS Cluster.
