# core/task

Module to create task definition. Mostly a module that is used internally by `core/service`

There should be no need to instantiate this module directly except if you know what you're doing.

Almost a 1-1 mapping to `resources`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| container\_definitions | Container definitions raw json string or rendered template. | `string` | n/a | yes |
| cpu | CPU unit for this task. | `number` | n/a | yes |
| create\_task\_definition | Create the Task Definition | `bool` | `true` | no |
| daemon\_role | The IAM Role to assign for the ECS container agent and Docker daemon. | `string` | n/a | yes |
| ipc\_mode | The IPC resource namespace to be used for the containers in the task The valid values are `host`, `task`, and `none`. | `string` | n/a | yes |
| memory | Memory for this task. | `number` | n/a | yes |
| name | The task name. | `string` | n/a | yes |
| network\_mode | The network mode for container. | `string` | `"bridge"` | no |
| pid\_mode | The process namespace to use for the containers in the task. The valid values are `host` and `task`. | `string` | n/a | yes |
| placement\_constraints | Placement constraints for Task Definition. List of map. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#placement_constraints) | `list(any)` | `[]` | no |
| proxy\_configuration | The proxy configuration details for the App Mesh proxy. Defined as map argument. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#proxy-configuration-arguments) | `any` | n/a | yes |
| requires\_compatibilites | A set of launch types required by the task. The valid values are EC2 and FARGATE. | `list(string)` | <pre>[<br>  "EC2"<br>]</pre> | no |
| tags | Key-value mapping of resource tags. | `map(string)` | `{}` | no |
| task\_role | The IAM Role to assign to the Container. | `string` | n/a | yes |
| volume\_configurations | Volume Block Arguments for Task Definition. List of map. Note that `docker_volume_configuration` should be specified as map argument instead of block. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#volume-block-arguments) | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Full ARN of the Task Definition (including both `family` and `revision`). |
| name | The created task definition name |
| revision | The revision number of the task definition |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


