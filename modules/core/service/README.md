# core/service

A Terraform module to define AWS ECS Service

Create ECS Service that can be connected to ELB/ALB

Offers creation of `task_definition` as well. By default, this will create corresponding `task_definition` for the service.

The goal of this module is to present a unified view between `ECS Service` and `ECS Task Definition` so only by defining `module "ecs"` and supplying `container_definitions` json, an ECS service would be up and running.

Since this module is the closest to the `resources` form, there are a lot of customization, for those who want it easy, do check the `simple` module instead of this `core` module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.85.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.85.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_task"></a> [task](#module\_task) | ../task | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.main_ignore_desired_count_changes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarms"></a> [alarms](#input\_alarms) | List of CloudWatch alarms to monitor for the service. If any alarm is in ALARM state, the service will be marked as unhealthy and will be stopped. | <pre>object({<br/>    alarm_names = list(string)<br/>    enable      = bool<br/>    rollback    = bool<br/>  })</pre> | `null` | no |
| <a name="input_availability_zone_rebalancing"></a> [availability\_zone\_rebalancing](#input\_availability\_zone\_rebalancing) | ECS automatically redistributes tasks within a service across Availability Zones (AZs) to mitigate the risk of impaired application availability due to underlying infrastructure failures and task lifecycle activities. The valid values are ENABLED and DISABLED. | `string` | `"DISABLED"` | no |
| <a name="input_capacity_provider_strategy"></a> [capacity\_provider\_strategy](#input\_capacity\_provider\_strategy) | List of map of the capacity provider strategy to use for the service. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#capacity_provider_strategy) | `list(any)` | `[]` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | The cluster name or ARN. | `string` | n/a | yes |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Container definitions raw json string or rendered template. Not required if `create_task_definition` is `false`. | `string` | `null` | no |
| <a name="input_create_task_definition"></a> [create\_task\_definition](#input\_create\_task\_definition) | Create the task definition | `bool` | `true` | no |
| <a name="input_deployment_controller"></a> [deployment\_controller](#input\_deployment\_controller) | Type of deployment controller. Valid values: `CODE_DEPLOY`, `ECS`. | `string` | `"ECS"` | no |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | upper limit (% of `desired_count`) of # of running tasks during a deployment. Do not fill when using `DAEMON` scheduling strategy. | `number` | `null` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | lower limit (% of `desired_count`) of # of running tasks during a deployment | `number` | `100` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | The number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the `DAEMON` scheduling strategy. | `number` | `null` | no |
| <a name="input_enable_deployment_circuit_breaker_with_rollback"></a> [enable\_deployment\_circuit\_breaker\_with\_rollback](#input\_enable\_deployment\_circuit\_breaker\_with\_rollback) | Enable Deployment Circuit Breaker with Rollback. When a service deployment fails, the service is rolled back to the last deployment that completed successfully. | `bool` | `false` | no |
| <a name="input_enable_deployment_circuit_breaker_without_rollback"></a> [enable\_deployment\_circuit\_breaker\_without\_rollback](#input\_enable\_deployment\_circuit\_breaker\_without\_rollback) | Enable Deployment Circuit Breaker without Rollback. | `bool` | `false` | no |
| <a name="input_enable_ecs_managed_tags"></a> [enable\_ecs\_managed\_tags](#input\_enable\_ecs\_managed\_tags) | Specifies whether to enable Amazon ECS managed tags for the tasks within the service. Boolean value. | `bool` | `null` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | Specifies whether to enable Amazon ECS Exec for the tasks within the service. | `bool` | `null` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Enable to delete a service even if it wasn't scaled down to zero tasks. It's only necessary to use this if the service uses the REPLICA scheduling strategy. | `bool` | `false` | no |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g. `myimage:latest`), roll Fargate tasks onto a newer platform version, or immediately deploy `ordered_placement_strategy` and `placement_constraints` updates. | `bool` | `null` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers. | `number` | `null` | no |
| <a name="input_iam_daemon_role"></a> [iam\_daemon\_role](#input\_iam\_daemon\_role) | IAM Role for ECS Agent and Docker Daemon to use (ECR, etc.). Required if specifying `repositoryCredentials` in container configuration. | `string` | `null` | no |
| <a name="input_iam_lb_role"></a> [iam\_lb\_role](#input\_iam\_lb\_role) | IAM Role ARN to use to attach service to Load Balancer. This parameter is required if you are using a load balancer with your service, but only if your task definition does not use the awsvpc network mode. If using awsvpc network mode, do not specify this role. If your account has already created the Amazon ECS service-linked role, that role is used by default for your service unless you specify a role here. | `string` | `null` | no |
| <a name="input_iam_task_role"></a> [iam\_task\_role](#input\_iam\_task\_role) | IAM Role for task to use to access AWS services (dynamo, s3, etc.) | `string` | `null` | no |
| <a name="input_ignore_desired_count_changes"></a> [ignore\_desired\_count\_changes](#input\_ignore\_desired\_count\_changes) | Ignores any changes to `desired_count` parameter after apply. Note updating this value will destroy the existing service and recreate it. | `bool` | `false` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | The launch type on which to run your service. The valid values are `EC2`,  `FARGATE` or `EXTERNAL`. | `string` | `null` | no |
| <a name="input_load_balancers"></a> [load\_balancers](#input\_load\_balancers) | List of map for load balancers configuration. | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The service name. | `string` | n/a | yes |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | Map of a network configuration for the service. This parameter is required for task definitions that use the awsvpc network mode to receive their own Elastic Network Interface, and it is not supported for other network modes. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#network_configuration) | `any` | `null` | no |
| <a name="input_ordered_placement_strategy"></a> [ordered\_placement\_strategy](#input\_ordered\_placement\_strategy) | List of map of service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. Max 5. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#ordered_placement_strategy) | <pre>list(object({<br/>    type  = string<br/>    field = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_platform_version"></a> [platform\_version](#input\_platform\_version) | The platform version on which to run your service. Only applicable for `launch_type` set to `FARGATE`. Defaults to `LATEST`. [AWS Docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html) | `string` | `null` | no |
| <a name="input_propagate_tags"></a> [propagate\_tags](#input\_propagate\_tags) | Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are `SERVICE` and `TASK_DEFINITION`. | `string` | `null` | no |
| <a name="input_scheduling_strategy"></a> [scheduling\_strategy](#input\_scheduling\_strategy) | The scheduling strategy to use for the service. The valid values are `REPLICA` and `DAEMON`. Fargate Tasks do not support `DAEMON` scheduling strategy. | `string` | `null` | no |
| <a name="input_service_connect_configuration"></a> [service\_connect\_configuration](#input\_service\_connect\_configuration) | The ECS Service Connect configuration for this service to discover and connect to services, and be discovered by, and connected from, other services within a namespace | <pre>object({<br/>    enabled = bool<br/>    log_configuration = optional(object({<br/>      log_driver = string<br/>      options    = optional(map(string))<br/>      secret_option = optional(object({<br/>        name       = string<br/>        value_from = string<br/>      }))<br/>    }))<br/>    namespace = optional(string)<br/>    service = optional(object({<br/>      client_alias = optional(list(object({<br/>        dns_name = optional(string)<br/>        port     = number<br/>      })), [])<br/>      discovery_name        = optional(string)<br/>      ingress_port_override = optional(number)<br/>      port_name             = string<br/>      timeout = optional(object({<br/>        idle_timeout_seconds        = optional(number)<br/>        per_request_timeout_seconds = optional(number)<br/>      }))<br/>      tls = optional(object({<br/>        issuer_cert_authority = object({<br/>          aws_pca_authority_arn = optional(string)<br/>        })<br/>        kms_key  = optional(string)<br/>        role_arn = optional(string)<br/>      }))<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_service_placement_constraints"></a> [service\_placement\_constraints](#input\_service\_placement\_constraints) | List of map of placement constraints for Service. Max 10. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#placement_constraints) | `list(any)` | `[]` | no |
| <a name="input_service_registry"></a> [service\_registry](#input\_service\_registry) | Map of a service discovery registries for the service. Consists of `registry_arn`, `port`(optional), `container_port`(optional), `container_port`(optional). [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#service_registries) | `any` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value mapping of resource tags | `map(string)` | `{}` | no |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | Task level CPU units. | `number` | `null` | no |
| <a name="input_task_definition_arn"></a> [task\_definition\_arn](#input\_task\_definition\_arn) | If `create_task_definition` is `false`, provide the ARN of task definition to use | `string` | `null` | no |
| <a name="input_task_enable_fault_injection"></a> [task\_enable\_fault\_injection](#input\_task\_enable\_fault\_injection) | Enables fault injection and allows for fault injection requests to be accepted from the task's containers. | `bool` | `false` | no |
| <a name="input_task_ephemeral_storage"></a> [task\_ephemeral\_storage](#input\_task\_ephemeral\_storage) | The amount of ephemeral storage to allocate for the task. This parameter is used to expand the total amount of ephemeral storage available, beyond the default amount, for tasks hosted on AWS Fargate. | <pre>object({<br/>    size_in_gib = number<br/>  })</pre> | `null` | no |
| <a name="input_task_ipc_mode"></a> [task\_ipc\_mode](#input\_task\_ipc\_mode) | The IPC resource namespace to be used for the containers in the task The valid values are `host`, `task`, and `none`. | `string` | `null` | no |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | Task level Memory units. | `number` | `null` | no |
| <a name="input_task_network_mode"></a> [task\_network\_mode](#input\_task\_network\_mode) | The network mode for container. | `string` | `"bridge"` | no |
| <a name="input_task_pid_mode"></a> [task\_pid\_mode](#input\_task\_pid\_mode) | The process namespace to use for the containers in the task. The valid values are `host` and `task`. | `string` | `null` | no |
| <a name="input_task_placement_constraints"></a> [task\_placement\_constraints](#input\_task\_placement\_constraints) | Placement constraints for Task Definition. List of map. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#placement_constraints) | <pre>list(object({<br/>    expression = optional(string)<br/>    type       = string<br/>  }))</pre> | `[]` | no |
| <a name="input_task_proxy_configuration"></a> [task\_proxy\_configuration](#input\_task\_proxy\_configuration) | The proxy configuration details for the App Mesh proxy. Defined as map argument. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#proxy_configuration) | `any` | `null` | no |
| <a name="input_task_requires_compatibilities"></a> [task\_requires\_compatibilities](#input\_task\_requires\_compatibilities) | A set of launch types required by the task. The valid values are `EC2` and `FARGATE`. | `list(string)` | <pre>[<br/>  "EC2"<br/>]</pre> | no |
| <a name="input_task_runtime_platform"></a> [task\_runtime\_platform](#input\_task\_runtime\_platform) | Runtime platform (operating system and CPU architecture) that containers may use. Defined as map argument. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#runtime_platform) | `any` | `null` | no |
| <a name="input_task_skip_destroy"></a> [task\_skip\_destroy](#input\_task\_skip\_destroy) | Whether to retain the old revision when the resource is destroyed or replacement is necessary. | `bool` | `false` | no |
| <a name="input_task_track_latest"></a> [task\_track\_latest](#input\_task\_track\_latest) | Whether should track latest ACTIVE task definition on AWS or the one created with the resource stored in state. | `bool` | `false` | no |
| <a name="input_task_volume_configurations"></a> [task\_volume\_configurations](#input\_task\_volume\_configurations) | Volume Block Arguments for Task Definition. List of map. Note that `docker_volume_configuration` should be specified as map argument instead of block. [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#volume) | `list(any)` | `[]` | no |
| <a name="input_volume_configuration"></a> [volume\_configuration](#input\_volume\_configuration) | Configuration for a volume specified in the task definition as a volume that is configured at launch time. Currently, the only supported volume type is an Amazon EBS volume. | <pre>list(object({<br/>    name = string<br/>    managed_ebs_volume = optional(object({<br/>      role_arn         = string<br/>      encrypted        = optional(bool, true)<br/>      file_system_type = optional(string)<br/>      iops             = optional(number)<br/>      kms_key_id       = optional(string)<br/>      size_in_gb       = optional(number)<br/>      snapshot_id      = optional(string)<br/>      throughput       = optional(number)<br/>      volume_type      = optional(string)<br/>      tag_specifications = optional(list(object({<br/>        resource_type  = string<br/>        propagate_tags = optional(string)<br/>        tags           = optional(map(string))<br/>      })), [])<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_vpc_lattice_configurations"></a> [vpc\_lattice\_configurations](#input\_vpc\_lattice\_configurations) | The VPC Lattice configuration for your service that allows Lattice to connect, secure, and monitor your service across multiple accounts and VPCs | <pre>list(object({<br/>    role_arn         = string<br/>    target_group_arn = string<br/>    port_name        = string<br/>  }))</pre> | `[]` | no |
| <a name="input_wait_for_steady_state"></a> [wait\_for\_steady\_state](#input\_wait\_for\_steady\_state) | If `true`, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing. | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster"></a> [cluster](#output\_cluster) | The name of the cluster which the service runs on |
| <a name="output_desired_count"></a> [desired\_count](#output\_desired\_count) | The number of instances of the task definition |
| <a name="output_id"></a> [id](#output\_id) | The Amazon Resource Name (ARN) that identifies the service |
| <a name="output_name"></a> [name](#output\_name) | The name of the service |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | The complete ARN of task definition generated includes Task Family and Task Revision |
| <a name="output_task_definition_name"></a> [task\_definition\_name](#output\_task\_definition\_name) | The name (family) of created Task Definition. |
| <a name="output_task_definition_revision"></a> [task\_definition\_revision](#output\_task\_definition\_revision) | The revision of the task in a particular family |
<!-- END_TF_DOCS -->
