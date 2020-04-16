# AWS Elastic Container Service (ECS) Terraform module

Terraform module which creates ECS resources on AWS.

These types of resources are supported:

* [ECS Cluster](https://github.com/HENNGE/terraform-aws-ecs)
* [ECS Service](https://github.com/HENNGE/terraform-aws-ecs/tree/master/modules/core/service)
* [ECS Task Definition](https://github.com/HENNGE/terraform-aws-ecs/tree/master/modules/core/task)
* [ECS Autoscaling](https://github.com/HENNGE/terraform-aws-ecs/tree/master/modules/autoscaling)

The root module (this) only creates `ecs_cluster`, to create other resources, please instantiate the submodules.

## Terraform versions

Supports only Terraform ~> 0.12.

Requires Terraform AWS Provider version >=2.42.0 for Capacity Provider options.

## Usage

```hcl
module "ecs_cluster" {
  source  = "HENNGE/ecs/aws"
  version = "1.0.0"

  name = "${local.prefix}-cluster"
}
```

## Examples

See examples folder for usage guide.

## Versioning

This module uses Semver.

`x.y.z`

`x` shall change when there's major language or breaking feature change (e.g. 0.11 to 0.12 which drastically change the language)

`y` shall change when there's feature addition which is not breaking existing API (e.g. addition of some parameters with default value)

`z` shall change when there's documentation updates, minor fixes, etc.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| capacity\_providers | List of short names or full Amazon Resource Names (ARNs) of one or more capacity providers to associate with the cluster. Valid values also include `FARGATE` and `FARGATE_SPOT`. | `list(string)` | n/a | yes |
| default\_capacity\_provider\_strategy | The capacity provider strategy to use by default for the cluster. Can be one or more. List of map with corresponding items in docs. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_cluster.html#default_capacity_provider_strategy) | `list(any)` | `[]` | no |
| name | Cluster name. | `any` | n/a | yes |
| settings | List of maps with cluster settings. For example, this can be used to enable CloudWatch Container Insights for a cluster. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_cluster.html#setting) | `list(any)` | `[]` | no |
| tags | Key-value mapping of resource tags. | `map(string)` | `{}` | no |

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
