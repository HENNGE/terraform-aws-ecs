

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| container\_definitions | Container definitions raw json string or rendered template. | string | n/a | yes |
| cpu | CPU unit for this task. | number | `"null"` | no |
| create\_task\_definition | Create the Task Definition | bool | `"true"` | no |
| daemon\_role | The IAM Role to assign for the ECS container agent and Docker daemon. | string | `"null"` | no |
| ipc\_mode | The IPC resource namespace to be used for the containers in the task The valid values are `host`, `task`, and `none`. | string | `"null"` | no |
| memory | Memory for this task. | number | `"null"` | no |
| name | The task name. | string | n/a | yes |
| network\_mode | The network mode for container. | string | `"bridge"` | no |
| pid\_mode | The process namespace to use for the containers in the task. The valid values are `host` and `task`. | string | `"null"` | no |
| placement\_constraints | Placement constraints for Task Definition. List of map. \[Terraform Docs\]\(https://www.terraform.io/docs/providers/aws/r/ecs\_task\_definition.html#placement\_constraints\) | list(any) | `[]` | no |
| proxy\_configuration | The proxy configuration details for the App Mesh proxy. Defined as map argument. \[Terraform Docs\]\(https://www.terraform.io/docs/providers/aws/r/ecs\_task\_definition.html#proxy-configuration-arguments\) | string | `"null"` | no |
| requires\_compatibilites | A set of launch types required by the task. The valid values are EC2 and FARGATE. | list(string) | `[ "EC2" ]` | no |
| tags | Key-value mapping of resource tags. | map(string) | `{}` | no |
| task\_role | The IAM Role to assign to the Container. | string | `"null"` | no |
| volume\_configurations | Volume Block Arguments for Task Definition. List of map. Note that `docker\_volume\_configuration` should be specified as map argument instead of block. \[Terraform Docs\]\(https://www.terraform.io/docs/providers/aws/r/ecs\_task\_definition.html#volume-block-arguments\) | list(any) | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Full ARN of the Task Definition \(including both `family` and `revision`\). |
| name | The created task definition name |
| revision | The revision number of the task definition |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


