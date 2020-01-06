

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster | The cluster name or ARN. | string | n/a | yes |
| container\_definitions | Container definitions raw json string or rendered template. Not required if `create\_task\_definition` is `false`. | string | n/a | yes |
| container\_name | Container name to register to Load Balancer | string | `"null"` | no |
| container\_port | The container port, must match the container exposed port | string | `"null"` | no |
| cpu | CPU unit for this task | number | `"null"` | no |
| deployment\_maximum\_percent | upper limit \(% of `desired\_count`\) of # of running tasks during a deployment. Do not fill when using `DAEMON` scheduling strategy. | number | `"null"` | no |
| deployment\_minimum\_healthy\_percent | lower limit \(% of `desired\_count`\) of # of running tasks during a deployment | number | `"100"` | no |
| desired\_count | The number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the `DAEMON` scheduling strategy. | number | `"null"` | no |
| elb\_name | Name of ELB \(Classic ELB\) to associate with the service | string | `"null"` | no |
| health\_check\_grace\_period\_seconds | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers. | number | `"null"` | no |
| iam\_daemon\_role | IAM Role for ECS Agent and Docker Daemon to use \(ECR, etc.\). Required if specifying `repositoryCredentials` in container configuration. | string | `"null"` | no |
| iam\_lb\_role | IAM Role ARN to use to attach service to Load Balancer. This parameter is required if you are using a load balancer with your service, but only if your task definition does not use the awsvpc network mode. If using awsvpc network mode, do not specify this role. If your account has already created the Amazon ECS service-linked role, that role is used by default for your service unless you specify a role here. | string | `"null"` | no |
| iam\_task\_role | IAM Role for task to use to access AWS services \(dynamo, s3, etc.\) | string | `"null"` | no |
| ignore\_desired\_count\_changes | Ignores any changes to `desired\_count` parameter after apply. Note updating this value will destroy the existing service and recreate it. | bool | `"false"` | no |
| memory | Memory for this task | number | `"null"` | no |
| name | The service name. | string | n/a | yes |
| network\_mode | Network mode of the container, valid options are none, bridge, awsvpc, and host | string | `"bridge"` | no |
| proxy\_configuration | The proxy configuration details for the App Mesh proxy. Defined as map argument. \[Terraform Docs\]\(https://www.terraform.io/docs/providers/aws/r/ecs\_task\_definition.html#proxy-configuration-arguments\) | string | `"null"` | no |
| service\_registry | Map of a service discovery registries for the service. Consists of `registry\_arn`, `port`\(optional\), `container\_port`\(optional\), `container\_port`\(optional\). \[Terraform Docs\]\(https://www.terraform.io/docs/providers/aws/r/ecs\_service.html#service\_registries\) | string | `"null"` | no |
| tags | Key-value mapping of resource tags | map(string) | `{}` | no |
| target\_group\_arn | ARN of the Application Load Balancer / Network Load Balancer target group | string | `"null"` | no |
| volume\_configurations | Volume Block Arguments for Task Definition. List of map. Note that `docker\_volume\_configuration` should be specified as map argument instead of block. \[Terraform Docs\]\(https://www.terraform.io/docs/providers/aws/r/ecs\_task\_definition.html#volume-block-arguments\) | list(any) | `[]` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


