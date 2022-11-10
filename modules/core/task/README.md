# core/task

Module to create task definition. Mostly a module that is used internally by `core/service`

There should be no need to instantiate this module directly except if you know what you're doing.

Almost a 1-1 mapping to `resources`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.74.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Container definitions raw json string or rendered template. | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU unit for this task. | `number` | `null` | no |
| <a name="input_create_task_definition"></a> [create\_task\_definition](#input\_create\_task\_definition) | Create the Task Definition | `bool` | `true` | no |
| <a name="input_daemon_role"></a> [daemon\_role](#input\_daemon\_role) | The IAM Role to assign for the ECS container agent and Docker daemon. | `string` | `null` | no |
| <a name="input_inference_accelerator"></a> [inference\_accelerator](#input\_inference\_accelerator) | Inference Accelerators settings. List of map. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#inference_accelerator) | `list(any)` | `[]` | no |
| <a name="input_ipc_mode"></a> [ipc\_mode](#input\_ipc\_mode) | The IPC resource namespace to be used for the containers in the task The valid values are `host`, `task`, and `none`. | `string` | `null` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for this task. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The task name. | `string` | n/a | yes |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | The network mode for container. | `string` | `"bridge"` | no |
| <a name="input_pid_mode"></a> [pid\_mode](#input\_pid\_mode) | The process namespace to use for the containers in the task. The valid values are `host` and `task`. | `string` | `null` | no |
| <a name="input_placement_constraints"></a> [placement\_constraints](#input\_placement\_constraints) | Placement constraints for Task Definition. List of map. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#placement_constraints) | `list(any)` | `[]` | no |
| <a name="input_proxy_configuration"></a> [proxy\_configuration](#input\_proxy\_configuration) | The proxy configuration details for the App Mesh proxy. Defined as map argument. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#proxy_configuration) | `any` | `null` | no |
| <a name="input_requires_compatibilites"></a> [requires\_compatibilites](#input\_requires\_compatibilites) | A set of launch types required by the task. The valid values are EC2 and FARGATE. | `list(string)` | <pre>[<br>  "EC2"<br>]</pre> | no |
| <a name="input_runtime_platform"></a> [runtime\_platform](#input\_runtime\_platform) | Runtime platform (operating system and CPU architecture) that containers may use. Defined as map argument. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#runtime_platform) | `any` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value mapping of resource tags. | `map(string)` | `{}` | no |
| <a name="input_task_role"></a> [task\_role](#input\_task\_role) | The IAM Role to assign to the Container. | `string` | `null` | no |
| <a name="input_volume_configurations"></a> [volume\_configurations](#input\_volume\_configurations) | Volume Block Arguments for Task Definition. List of map. Note that `docker_volume_configuration` should be specified as map argument instead of block. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#volume) | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Full ARN of the Task Definition (including both `family` and `revision`). |
| <a name="output_name"></a> [name](#output\_name) | The created task definition name |
| <a name="output_revision"></a> [revision](#output\_revision) | The revision number of the task definition |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


