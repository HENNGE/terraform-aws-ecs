# simple/fargate

A Terraform module to create `ECS Service` that is launched on `FARGATE` (not `EC2`)

Just by supplying `container_definitions` json, and few parameters, an ECS Service should be up and ready.

This can also create an `ECS Service` that is connected to `Load Balancer`

See [example](https://github.com/HENNGE/terraform-aws-ecs/tree/main/examples/easy/fargate) for usage.

## Components

Creates the following:
- ECS Service
- ECS Task Definition

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.85.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_fargate"></a> [fargate](#module\_fargate) | ../../core/service | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarms"></a> [alarms](#input\_alarms) | List of CloudWatch alarms to monitor for the service. If any alarm is in ALARM state, the service will be marked as unhealthy and will be stopped. | <pre>object({<br/>    alarm_names = list(string)<br/>    enable      = bool<br/>    rollback    = bool<br/>  })</pre> | `null` | no |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Assign public IP to the ENI | `bool` | `false` | no |
| <a name="input_availability_zone_rebalancing"></a> [availability\_zone\_rebalancing](#input\_availability\_zone\_rebalancing) | If `ENABLED`, ECS will rebalance tasks across Availability Zones in the cluster when a new task is launched. This is only applicable to services that use the `REPLICA` scheduling strategy. | `string` | `"DISABLED"` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | The cluster name or ARN. | `string` | n/a | yes |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Container definitions raw json string or rendered template. Not required if `create_task_definition` is `false`. | `string` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Container name to register to Load Balancer | `string` | `null` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | The container port, must match the container exposed port | `string` | `null` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU unit for this task | `number` | n/a | yes |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | upper limit (% of `desired_count`) of # of running tasks during a deployment. Do not fill when using `DAEMON` scheduling strategy. | `number` | `null` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | lower limit (% of `desired_count`) of # of running tasks during a deployment | `number` | `100` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | The number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the `DAEMON` scheduling strategy. | `number` | `null` | no |
| <a name="input_elb_name"></a> [elb\_name](#input\_elb\_name) | Name of ELB (Classic ELB) to associate with the service | `string` | `null` | no |
| <a name="input_enable_deployment_circuit_breaker_with_rollback"></a> [enable\_deployment\_circuit\_breaker\_with\_rollback](#input\_enable\_deployment\_circuit\_breaker\_with\_rollback) | Enable Deployment Circuit Breaker with Rollback. When a service deployment fails, the service is rolled back to the last deployment that completed successfully. | `bool` | `false` | no |
| <a name="input_enable_deployment_circuit_breaker_without_rollback"></a> [enable\_deployment\_circuit\_breaker\_without\_rollback](#input\_enable\_deployment\_circuit\_breaker\_without\_rollback) | Enable Deployment Circuit Breaker without Rollback. | `bool` | `false` | no |
| <a name="input_enable_ecs_managed_tags"></a> [enable\_ecs\_managed\_tags](#input\_enable\_ecs\_managed\_tags) | Specifies whether to enable Amazon ECS managed tags for the tasks within the service. Boolean value. | `bool` | `null` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | Specifies whether to enable Amazon ECS Exec for the tasks within the service. | `bool` | `null` | no |
| <a name="input_enable_fault_injection"></a> [enable\_fault\_injection](#input\_enable\_fault\_injection) | Enables fault injection and allows for fault injection requests to be accepted from the task's containers. | `bool` | `false` | no |
| <a name="input_ephemeral_storage"></a> [ephemeral\_storage](#input\_ephemeral\_storage) | The amount of ephemeral storage to allocate for the task. This parameter is used to expand the total amount of ephemeral storage available, beyond the default amount, for tasks hosted on AWS Fargate. | <pre>object({<br/>    size_in_gib = number<br/>  })</pre> | `null` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Enable to delete a service even if it wasn't scaled down to zero tasks. It's only necessary to use this if the service uses the REPLICA scheduling strategy. | `bool` | `false` | no |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g. `myimage:latest`), roll Fargate tasks onto a newer platform version, or immediately deploy `ordered_placement_strategy` and `placement_constraints` updates. | `bool` | `null` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers. | `number` | `null` | no |
| <a name="input_iam_daemon_role"></a> [iam\_daemon\_role](#input\_iam\_daemon\_role) | IAM Role for ECS Agent and Docker Daemon to use (ECR, etc.). Required if specifying `repositoryCredentials` in container configuration. | `string` | `null` | no |
| <a name="input_iam_lb_role"></a> [iam\_lb\_role](#input\_iam\_lb\_role) | IAM Role ARN to use to attach service to Load Balancer. This parameter is required if you are using a load balancer with your service, but only if your task definition does not use the awsvpc network mode. If using awsvpc network mode, do not specify this role. If your account has already created the Amazon ECS service-linked role, that role is used by default for your service unless you specify a role here. | `string` | `null` | no |
| <a name="input_iam_task_role"></a> [iam\_task\_role](#input\_iam\_task\_role) | IAM Role for task to use to access AWS services (dynamo, s3, etc.) | `string` | `null` | no |
| <a name="input_ignore_desired_count_changes"></a> [ignore\_desired\_count\_changes](#input\_ignore\_desired\_count\_changes) | Ignores any changes to `desired_count` parameter after apply. Note updating this value will destroy the existing service and recreate it. | `bool` | `false` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for this task | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The service name. | `string` | n/a | yes |
| <a name="input_ordered_placement_strategy"></a> [ordered\_placement\_strategy](#input\_ordered\_placement\_strategy) | List of map of service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. Max 5. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#ordered_placement_strategy) | <pre>list(object({<br/>    type  = string<br/>    field = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_placement_constraints"></a> [placement\_constraints](#input\_placement\_constraints) | Placement constraints for Task Definition. List of map. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#placement_constraints) | <pre>list(object({<br/>    expression = optional(string)<br/>    type       = string<br/>  }))</pre> | `[]` | no |
| <a name="input_platform_version"></a> [platform\_version](#input\_platform\_version) | The platform version on which to run your service. Defaults to `LATEST`. [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html) | `string` | `null` | no |
| <a name="input_propagate_tags"></a> [propagate\_tags](#input\_propagate\_tags) | Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are `SERVICE` and `TASK_DEFINITION`. | `string` | `null` | no |
| <a name="input_proxy_configuration"></a> [proxy\_configuration](#input\_proxy\_configuration) | The proxy configuration details for the App Mesh proxy. Defined as map argument. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#proxy_configuration) | `any` | `null` | no |
| <a name="input_runtime_platform"></a> [runtime\_platform](#input\_runtime\_platform) | Runtime platform (operating system and CPU architecture) that containers may use. Defined as map argument. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#runtime_platform) | `any` | `null` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Security Groups to apply for the task | `list(string)` | n/a | yes |
| <a name="input_service_connect_configuration"></a> [service\_connect\_configuration](#input\_service\_connect\_configuration) | The ECS Service Connect configuration for this service to discover and connect to services, and be discovered by, and connected from, other services within a namespace | <pre>object({<br/>    enabled = bool<br/>    log_configuration = optional(object({<br/>      log_driver = string<br/>      options    = optional(map(string))<br/>      secret_option = optional(object({<br/>        name       = string<br/>        value_from = string<br/>      }))<br/>    }))<br/>    namespace = optional(string)<br/>    service = optional(object({<br/>      client_alias = optional(list(object({<br/>        dns_name = optional(string)<br/>        port     = number<br/>      })), [])<br/>      discovery_name        = optional(string)<br/>      ingress_port_override = optional(number)<br/>      port_name             = string<br/>      timeout = optional(object({<br/>        idle_timeout_seconds        = optional(number)<br/>        per_request_timeout_seconds = optional(number)<br/>      }))<br/>      tls = optional(object({<br/>        issuer_cert_authority = object({<br/>          aws_pca_authority_arn = optional(string)<br/>        })<br/>        kms_key  = optional(string)<br/>        role_arn = optional(string)<br/>      }))<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_service_registry"></a> [service\_registry](#input\_service\_registry) | Map of a service discovery registries for the service. Consists of `registry_arn`, `port`(optional), `container_port`(optional), `container_port`(optional). [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#service_registries) | `any` | `null` | no |
| <a name="input_skip_destroy"></a> [skip\_destroy](#input\_skip\_destroy) | Whether to retain the old revision when the resource is destroyed or replacement is necessary. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value mapping of resource tags | `map(string)` | `{}` | no |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | ARN of the Application Load Balancer / Network Load Balancer target group | `string` | `null` | no |
| <a name="input_task_volume_configurations"></a> [task\_volume\_configurations](#input\_task\_volume\_configurations) | Volume Block Arguments for Task Definition. List of map. Note that `docker_volume_configuration` should be specified as map argument instead of block. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#volume) | `list(any)` | `[]` | no |
| <a name="input_track_latest"></a> [track\_latest](#input\_track\_latest) | Whether should track latest ACTIVE task definition on AWS or the one created with the resource stored in state. | `bool` | `false` | no |
| <a name="input_volume_configuration"></a> [volume\_configuration](#input\_volume\_configuration) | Configuration for a volume specified in the task definition as a volume that is configured at launch time. Currently, the only supported volume type is an Amazon EBS volume. | <pre>list(object({<br/>    name = string<br/>    managed_ebs_volume = optional(object({<br/>      role_arn         = string<br/>      encrypted        = optional(bool, true)<br/>      file_system_type = optional(string)<br/>      iops             = optional(number)<br/>      kms_key_id       = optional(string)<br/>      size_in_gb       = optional(number)<br/>      snapshot_id      = optional(string)<br/>      throughput       = optional(number)<br/>      volume_type      = optional(string)<br/>      tag_specifications = optional(list(object({<br/>        resource_type  = string<br/>        propagate_tags = optional(string)<br/>        tags           = optional(map(string))<br/>      })), [])<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_vpc_lattice_configurations"></a> [vpc\_lattice\_configurations](#input\_vpc\_lattice\_configurations) | The VPC Lattice configuration for your service that allows Lattice to connect, secure, and monitor your service across multiple accounts and VPCs | <pre>list(object({<br/>    role_arn         = string<br/>    target_group_arn = string<br/>    port_name        = string<br/>  }))</pre> | `[]` | no |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | VPC Subnets where the tasks should live in | `list(string)` | n/a | yes |
| <a name="input_wait_for_steady_state"></a> [wait\_for\_steady\_state](#input\_wait\_for\_steady\_state) | If `true`, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing. | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster"></a> [cluster](#output\_cluster) | The Amazon Resource Name (ARN) of cluster which the service runs on |
| <a name="output_desired_count"></a> [desired\_count](#output\_desired\_count) | The number of instances of the task definition |
| <a name="output_id"></a> [id](#output\_id) | The Amazon Resource Name (ARN) that identifies the service |
| <a name="output_name"></a> [name](#output\_name) | The name of the service |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | The complete ARN of task definition generated includes Task Family and Task Revision |
| <a name="output_task_definition_name"></a> [task\_definition\_name](#output\_task\_definition\_name) | The name (family) of created Task Definition. |
| <a name="output_task_definition_revision"></a> [task\_definition\_revision](#output\_task\_definition\_revision) | The revision of the task in a particular family |
<!-- END_TF_DOCS -->
