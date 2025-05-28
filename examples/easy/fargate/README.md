# examples/easy/fargate

In this example we'll instantiate a simple nginx webserver

This example will also create `vpc` and `security_group` to run fargate tasks.

To test that it's working:
1. Go to ECS Console
1. Find the created ECS cluster, click the cluster, you should see the cluster info screen
1. Click on the service
1. Go to `Tasks` tab
1. Click on one of the task
1. Find the public IP of the task
1. Try putting the IP to your browser, you should see nginx hello world screen

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.85.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.85.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_easy_fargate"></a> [easy\_fargate](#module\_easy\_fargate) | ../../../modules/simple/fargate | n/a |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | ../../.. | n/a |
| <a name="module_task_security_group"></a> [task\_security\_group](#module\_task\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | Name of the ECS Cluster created |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | Name of the ECS Service created |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
