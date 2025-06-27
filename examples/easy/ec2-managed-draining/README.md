# examples/easy/ec2-managed-draining

In this example we'll instantiate a simple nginx webserver, running on EC2 Auto Scaling Group, with managed draining feature enabled.
This means ECS will monitor the Auto Scaling Group and set an instance's status to draining when it's scheduled for termination.
With draining status set, ECS will safely terminate all tasks running on the instance and create replacement tasks in other instance(s).

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_asg"></a> [asg](#module\_asg) | terraform-aws-modules/autoscaling/aws | ~> 9.0 |
| <a name="module_easy_ec2"></a> [easy\_ec2](#module\_easy\_ec2) | ../../../modules/simple/ec2 | n/a |
| <a name="module_ec2_security_group"></a> [ec2\_security\_group](#module\_ec2\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | ../../.. | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_capacity_provider.asg_managed_draining](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
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
