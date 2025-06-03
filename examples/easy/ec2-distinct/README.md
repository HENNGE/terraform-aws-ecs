# examples/easy/ec2-distinct

In this example we'll instantiate a simple nginx webserver running in **3 distinct instances**.

Task networking mode in this example is `host` so that the port specified in `templates/container_definitions.tpl` will be bind.
Means there cannot be more than 1 task in an instance. Do experiment with dynamic port mapping with `bridge` network mode.

This example will also create `vpc` and `security_group` and `autoscaling group`.

Note: Instance profile is required for EC2 to connect to ECS Cluster. See [`modules/iam/ecs-instance-profile`](https://github.com/HENNGE/terraform-aws-ecs/tree/main/modules/iam/ecs-instance-profile).

To test that it's working:
1. Go to EC2 console
1. Find the EC2 instance started by this example. (Search the name)
1. Go to the IP Address, you should see nginx hello world screen

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```


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
| <a name="module_asg"></a> [asg](#module\_asg) | terraform-aws-modules/autoscaling/aws | ~> 7.0 |
| <a name="module_easy_ec2_distinct_instance_mode"></a> [easy\_ec2\_distinct\_instance\_mode](#module\_easy\_ec2\_distinct\_instance\_mode) | ../../../modules/simple/ec2 | n/a |
| <a name="module_ec2_security_group"></a> [ec2\_security\_group](#module\_ec2\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | ../../.. | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_ssm_parameter.ami_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Override automatic detection of availability zones | `list(string)` | `[]` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Enable IPv6? | `bool` | `true` | no |
| <a name="input_instance_profile_arn"></a> [instance\_profile\_arn](#input\_instance\_profile\_arn) | Instance Profile to use for EC2 to join to ECS Cluster. See `modules/iam/ecs-instance-profile` | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
