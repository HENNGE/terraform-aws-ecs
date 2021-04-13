# simple/ec2

A Terraform module to create `ECS Service` that is launched on `EC2` (not `FARGATE`)

Just by supplying `container_definitions` json, and few parameters, an ECS Service should be up and ready.

This can also create an `ECS Service` that is connected to `Load Balancer`

See [example](https://github.com/HENNGE/terraform-aws-ecs/tree/main/examples/easy/ec2) for usage.

## Components

Creates the following:
- ECS Service
- ECS Task Definition

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | >= 3.35.0 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| capacity\_provider\_arn | Run the service only on this capacity provider | `string` | `null` | no |
| cluster | The cluster name or ARN. | `string` | n/a | yes |
| container\_definitions | Container definitions raw json string or rendered template. Not required if `create_task_definition` is `false`. | `string` | n/a | yes |
| container\_name | Container name to register to Load Balancer | `string` | `null` | no |
| container\_port | The container port, must match the container exposed port | `string` | `null` | no |
| cpu | CPU unit for this task | `number` | `null` | no |
| deployment\_maximum\_percent | upper limit (% of `desired_count`) of # of running tasks during a deployment. Do not fill when using `DAEMON` scheduling strategy. | `number` | `null` | no |
| deployment\_minimum\_healthy\_percent | lower limit (% of `desired_count`) of # of running tasks during a deployment | `number` | `100` | no |
| desired\_count | The number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the `DAEMON` scheduling strategy. | `number` | `null` | no |
| elb\_name | Name of ELB (Classic ELB) to associate with the service | `string` | `null` | no |
| enable\_deployment\_circuit\_breaker\_with\_rollback | Enable Deployment Circuit Breaker with Rollback. When a service deployment fails, the service is rolled back to the last deployment that completed successfully. | `bool` | `false` | no |
| enable\_deployment\_circuit\_breaker\_without\_rollback | Enable Deployment Circuit Breaker without Rollback. | `bool` | `false` | no |
| enable\_ecs\_managed\_tags | Specifies whether to enable Amazon ECS managed tags for the tasks within the service. Boolean value. | `bool` | `null` | no |
| force\_new\_deployment | Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g. `myimage:latest`), roll Fargate tasks onto a newer platform version, or immediately deploy `ordered_placement_strategy` and `placement_constraints` updates. | `bool` | `null` | no |
| health\_check\_grace\_period\_seconds | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers. | `number` | `null` | no |
| iam\_daemon\_role | IAM Role for ECS Agent and Docker Daemon to use (ECR, etc.). Required if specifying `repositoryCredentials` in container configuration. | `string` | `null` | no |
| iam\_lb\_role | IAM Role ARN to use to attach service to Load Balancer. This parameter is required if you are using a load balancer with your service, but only if your task definition does not use the awsvpc network mode. If using awsvpc network mode, do not specify this role. If your account has already created the Amazon ECS service-linked role, that role is used by default for your service unless you specify a role here. | `string` | `null` | no |
| iam\_task\_role | IAM Role for task to use to access AWS services (dynamo, s3, etc.) | `string` | `null` | no |
| ignore\_desired\_count\_changes | Ignores any changes to `desired_count` parameter after apply. Note updating this value will destroy the existing service and recreate it. | `bool` | `false` | no |
| memory | Memory for this task | `number` | `null` | no |
| name | The service name. | `string` | n/a | yes |
| network\_mode | Network mode of the container, valid options are none, bridge, awsvpc, and host | `string` | `"bridge"` | no |
| propagate\_tags | Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are `SERVICE` and `TASK_DEFINITION`. | `string` | `null` | no |
| proxy\_configuration | The proxy configuration details for the App Mesh proxy. Defined as map argument. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#proxy-configuration-arguments) | `any` | `null` | no |
| service\_registry | Map of a service discovery registries for the service. Consists of `registry_arn`, `port`(optional), `container_port`(optional), `container_port`(optional). [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_service.html#service_registries) | `any` | `null` | no |
| tags | Key-value mapping of resource tags | `map(string)` | `{}` | no |
| target\_group\_arn | ARN of the Application Load Balancer / Network Load Balancer target group | `string` | `null` | no |
| volume\_configurations | Volume Block Arguments for Task Definition. List of map. Note that `docker_volume_configuration` should be specified as map argument instead of block. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#volume-block-arguments) | `list(any)` | `[]` | no |
| wait\_for\_steady\_state | If `true`, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing. | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster | The Amazon Resource Name (ARN) of cluster which the service runs on |
| desired\_count | The number of instances of the task definition |
| id | The Amazon Resource Name (ARN) that identifies the service |
| name | The name of the service |
| task\_definition\_arn | The complete ARN of task definition generated includes Task Family and Task Revision |
| task\_definition\_name | The name (family) of created Task Definition. |
| task\_definition\_revision | The revision of the task in a particular family |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


