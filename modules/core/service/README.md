# core/service

A Terraform module to define AWS ECS Service

Create ECS Service that can be connected to ELB/ALB

Offers creation of `task_definition` as well. By default, this will create corresponding `task_definition` for the service.

The goal of this module is to present a unified view between `ECS Service` and `ECS Task Definition` so only by defining `module "ecs"` and supplying `container_definitions` json, an ECS service would be up and running.

Since this module is the closest to the `resources` form, there are a lot of customization, for those who want it easy, do check the `simple` module instead of this `core` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| capacity\_provider\_strategy | List of map of the capacity provider strategy to use for the service. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_service.html#capacity_provider_strategy) | `list(any)` | `[]` | no |
| cluster | The cluster name or ARN. | `string` | n/a | yes |
| container\_definitions | Container definitions raw json string or rendered template. Not required if `create_task_definition` is `false`. | `string` | `null` | no |
| create\_task\_definition | Create the task definition | `bool` | `true` | no |
| deployment\_controller | Type of deployment controller. Valid values: `CODE_DEPLOY`, `ECS`. | `string` | `"ECS"` | no |
| deployment\_maximum\_percent | upper limit (% of `desired_count`) of # of running tasks during a deployment. Do not fill when using `DAEMON` scheduling strategy. | `number` | `null` | no |
| deployment\_minimum\_healthy\_percent | lower limit (% of `desired_count`) of # of running tasks during a deployment | `number` | `100` | no |
| desired\_count | The number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the `DAEMON` scheduling strategy. | `number` | `null` | no |
| enable\_ecs\_managed\_tags | Specifies whether to enable Amazon ECS managed tags for the tasks within the service. Boolean value. | `any` | `null` | no |
| health\_check\_grace\_period\_seconds | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers. | `number` | `null` | no |
| iam\_daemon\_role | IAM Role for ECS Agent and Docker Daemon to use (ECR, etc.). Required if specifying `repositoryCredentials` in container configuration. | `string` | `null` | no |
| iam\_lb\_role | IAM Role ARN to use to attach service to Load Balancer. This parameter is required if you are using a load balancer with your service, but only if your task definition does not use the awsvpc network mode. If using awsvpc network mode, do not specify this role. If your account has already created the Amazon ECS service-linked role, that role is used by default for your service unless you specify a role here. | `string` | `null` | no |
| iam\_task\_role | IAM Role for task to use to access AWS services (dynamo, s3, etc.) | `string` | `null` | no |
| ignore\_desired\_count\_changes | Ignores any changes to `desired_count` parameter after apply. Note updating this value will destroy the existing service and recreate it. | `bool` | `false` | no |
| launch\_type | The launch type on which to run your service. The valid values are `EC2` or `FARGATE`. | `string` | `null` | no |
| load\_balancers | List of map for load balancers configuration. | `list(any)` | `[]` | no |
| name | The service name. | `string` | n/a | yes |
| network\_configuration | Map of a network configuration for the service. This parameter is required for task definitions that use the awsvpc network mode to receive their own Elastic Network Interface, and it is not supported for other network modes. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_service.html#network_configuration) | `any` | `null` | no |
| ordered\_placement\_strategy | List of map of service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. Max 5. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_service.html#ordered_placement_strategy) | `list(any)` | `[]` | no |
| placement\_constraints | List of map of placement constraints for Task Definition. Max 10. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_service.html#placement_constraints) | `list(any)` | `[]` | no |
| platform\_version | The platform version on which to run your service. Only applicable for `launch_type` set to `FARGATE`. Defaults to `LATEST`. [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html) | `string` | `null` | no |
| propagate\_tags | Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are `SERVICE` and `TASK_DEFINITION`. | `string` | `null` | no |
| scheduling\_strategy | The scheduling strategy to use for the service. The valid values are `REPLICA` and `DAEMON`. Fargate Tasks do not support `DAEMON` scheduling strategy. | `string` | `null` | no |
| service\_registry | Map of a service discovery registries for the service. Consists of `registry_arn`, `port`(optional), `container_port`(optional), `container_port`(optional). [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_service.html#service_registries) | `any` | `null` | no |
| tags | Key-value mapping of resource tags | `map(string)` | `{}` | no |
| task\_cpu | Task level CPU units. | `number` | `null` | no |
| task\_definition\_arn | If `create_task_definition` is `false`, provide the ARN of task definition to use | `string` | `null` | no |
| task\_ipc\_mode | The IPC resource namespace to be used for the containers in the task The valid values are `host`, `task`, and `none`. | `string` | `null` | no |
| task\_memory | Task level Memory units. | `number` | `null` | no |
| task\_network\_mode | The network mode for container. | `string` | `"bridge"` | no |
| task\_pid\_mode | The process namespace to use for the containers in the task. The valid values are `host` and `task`. | `string` | `null` | no |
| task\_proxy\_configuration | The proxy configuration details for the App Mesh proxy. Defined as map argument. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#proxy-configuration-arguments) | `any` | `null` | no |
| task\_requires\_compatibilites | A set of launch types required by the task. The valid values are `EC2` and `FARGATE`. | `list(string)` | <pre>[<br>  "EC2"<br>]</pre> | no |
| task\_volume\_configurations | Volume Block Arguments for Task Definition. List of map. Note that `docker_volume_configuration` should be specified as map argument instead of block. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#volume-block-arguments) | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster | The name of the cluster which the service runs on |
| desired\_count | The number of instances of the task definition |
| id | The Amazon Resource Name (ARN) that identifies the service |
| name | The name of the service |
| task\_definition\_arn | The complete ARN of task definition generated includes Task Family and Task Revision |
| task\_definition\_name | The name (family) of created Task Definition. |
| task\_definition\_revision | The revision of the task in a particular family |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


