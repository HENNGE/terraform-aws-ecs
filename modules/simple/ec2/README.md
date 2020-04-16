# simple/ec2

A Terraform module to create `ECS Service` that is launched on `EC2` (not `FARGATE`)

Just by supplying `container_definitions` json, and few parameters, an ECS Service should be up and ready.

This can also create an `ECS Service` that is connected to `Load Balancer`

See [example](https://github.com/HENNGE/terraform-aws-ecs/tree/master/examples/easy/ec2) for usage.

## Components

Creates the following:
- ECS Service
- ECS Task Definition

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| capacity\_provider\_arn | Run the service only on this capacity provider | `string` | n/a | yes |
| cluster | The cluster name or ARN. | `string` | n/a | yes |
| container\_definitions | Container definitions raw json string or rendered template. Not required if `create_task_definition` is `false`. | `string` | n/a | yes |
| container\_name | Container name to register to Load Balancer | `string` | n/a | yes |
| container\_port | The container port, must match the container exposed port | `string` | n/a | yes |
| cpu | CPU unit for this task | `number` | n/a | yes |
| deployment\_maximum\_percent | upper limit (% of `desired_count`) of # of running tasks during a deployment. Do not fill when using `DAEMON` scheduling strategy. | `number` | n/a | yes |
| deployment\_minimum\_healthy\_percent | lower limit (% of `desired_count`) of # of running tasks during a deployment | `number` | `100` | no |
| desired\_count | The number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the `DAEMON` scheduling strategy. | `number` | n/a | yes |
| elb\_name | Name of ELB (Classic ELB) to associate with the service | `string` | n/a | yes |
| health\_check\_grace\_period\_seconds | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers. | `number` | n/a | yes |
| iam\_daemon\_role | IAM Role for ECS Agent and Docker Daemon to use (ECR, etc.). Required if specifying `repositoryCredentials` in container configuration. | `string` | n/a | yes |
| iam\_lb\_role | IAM Role ARN to use to attach service to Load Balancer. This parameter is required if you are using a load balancer with your service, but only if your task definition does not use the awsvpc network mode. If using awsvpc network mode, do not specify this role. If your account has already created the Amazon ECS service-linked role, that role is used by default for your service unless you specify a role here. | `string` | n/a | yes |
| iam\_task\_role | IAM Role for task to use to access AWS services (dynamo, s3, etc.) | `string` | n/a | yes |
| ignore\_desired\_count\_changes | Ignores any changes to `desired_count` parameter after apply. Note updating this value will destroy the existing service and recreate it. | `bool` | `false` | no |
| memory | Memory for this task | `number` | n/a | yes |
| name | The service name. | `string` | n/a | yes |
| network\_mode | Network mode of the container, valid options are none, bridge, awsvpc, and host | `string` | `"bridge"` | no |
| proxy\_configuration | The proxy configuration details for the App Mesh proxy. Defined as map argument. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#proxy-configuration-arguments) | `any` | n/a | yes |
| service\_registry | Map of a service discovery registries for the service. Consists of `registry_arn`, `port`(optional), `container_port`(optional), `container_port`(optional). [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_service.html#service_registries) | `any` | n/a | yes |
| tags | Key-value mapping of resource tags | `map(string)` | `{}` | no |
| target\_group\_arn | ARN of the Application Load Balancer / Network Load Balancer target group | `string` | n/a | yes |
| volume\_configurations | Volume Block Arguments for Task Definition. List of map. Note that `docker_volume_configuration` should be specified as map argument instead of block. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#volume-block-arguments) | `list(any)` | `[]` | no |

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


