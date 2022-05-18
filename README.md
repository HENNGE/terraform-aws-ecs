# AWS Elastic Container Service (ECS) Terraform module

Terraform module which creates ECS resources on AWS.

These types of resources are supported:

* [ECS Cluster](https://github.com/HENNGE/terraform-aws-ecs)
* [ECS Service](https://github.com/HENNGE/terraform-aws-ecs/tree/main/modules/core/service)
* [ECS Task Definition](https://github.com/HENNGE/terraform-aws-ecs/tree/main/modules/core/task)
* [ECS Autoscaling](https://github.com/HENNGE/terraform-aws-ecs/tree/main/modules/autoscaling)

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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.35.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity_providers"></a> [capacity\_providers](#input\_capacity\_providers) | List of short names or full Amazon Resource Names (ARNs) of one or more capacity providers to associate with the cluster. Valid values also include `FARGATE` and `FARGATE_SPOT`. | `list(string)` | `null` | no |
| <a name="input_default_capacity_provider_strategy"></a> [default\_capacity\_provider\_strategy](#input\_default\_capacity\_provider\_strategy) | The capacity provider strategy to use by default for the cluster. Can be one or more. List of map with corresponding items in docs. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_cluster.html#default_capacity_provider_strategy) | `list(any)` | `[]` | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | Enable container insights. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Cluster name. | `string` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | List of maps with cluster settings. For example, this can be used to enable CloudWatch Container Insights for a cluster. [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/ecs_cluster.html#setting) | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value mapping of resource tags. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the generated cluster |
| <a name="output_name"></a> [name](#output\_name) | Name of the Cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Authors

Module managed by [HENNGE](https://github.com/HENNGE).

## License

Apache 2 Licensed. See LICENSE for full details.
