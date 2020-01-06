# AWS Elastic Container Service (ECS) Terraform module

Terraform module which creates ECS resources on AWS.

These types of resources are supported:

* [ECS Cluster]()
* [ECS Service]()
* [ECS Task Definition]()
* [ECS Autoscaling]

//<!insert more readme here>

## Terraform versions

Supports only Terraform ~> 0.12.

Requires Terraform AWS Provider version >=2.42.0 for Capacity Provider options.

## Usage

```hcl

```

## Examples

//<!insert examples here>


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| capacity\_providers | List of short names or full Amazon Resource Names \(ARNs\) of one or more capacity providers to associate with the cluster. Valid values also include `FARGATE` and `FARGATE\_SPOT`. | list(string) | `"null"` | no |
| default\_capacity\_provider\_strategy | The capacity provider strategy to use by default for the cluster. Can be one or more. List of map with corresponding items in docs. \[Terraform Docs\]\(https://www.terraform.io/docs/providers/aws/r/ecs\_cluster.html#default\_capacity\_provider\_strategy\) | list(any) | `[]` | no |
| name | Cluster name. | string | n/a | yes |
| settings | List of maps with cluster settings. For example, this can be used to enable CloudWatch Container Insights for a cluster. \[Terraform Docs\]\(https://www.terraform.io/docs/providers/aws/r/ecs\_cluster.html#setting\) | list(any) | `[]` | no |
| tags | Key-value mapping of resource tags. | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the generated cluster |
| name | Name of the Cluster |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Authors

Module managed by [HENNGE](https://github.com/HENNGE).

## License

Apache 2 Licensed. See LICENSE for full details.
