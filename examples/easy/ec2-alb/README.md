# examples/easy/ec2-alb

In this example we'll instantiate a simple nginx webserver placed behind an `Application Load Balancer`.

Task networking mode in this example is `bridge` and will use dynamic port mapping, thus we can have multiple task running in 1 ec2 instance.

This example will also create `vpc` and `security_group` and `autoscaling group`.

Note: Instance profile is required for EC2 to connect to ECS Cluster. See [`modules/iam/ecs-instance-profile`](https://github.com/HENNGE/terraform-aws-ecs/tree/main/modules/iam/ecs-instance-profile).

To test that it's working:
1. Go to ECS Console
1. Find the created ECS cluster, click the cluster, you should see the cluster info screen
1. Click on the service
1. Go to `Tasks` tab
1. Click on one of the task
1. Find the public IP of the task
1. Try putting the IP to your browser, you should *NOT* see nginx hello world screen (this example blocks traffic with security group, disabling public ip assignment to fargate should also work if the container does not need to actively contact the outside world)
1. Try putting DNS outputted by the example / find the DNS name of created Load Balancer
1. Nginx hello world screen should appear

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
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | 5.13.0 |
| <a name="module_alb_security_group"></a> [alb\_security\_group](#module\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_asg"></a> [asg](#module\_asg) | terraform-aws-modules/autoscaling/aws | ~> 7.0 |
| <a name="module_easy_ec2"></a> [easy\_ec2](#module\_easy\_ec2) | ../../../modules/simple/ec2 | n/a |
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

| Name | Description |
|------|-------------|
| <a name="output_load_balancer_dns"></a> [load\_balancer\_dns](#output\_load\_balancer\_dns) | Accessible load balancer DNS |
<!-- END_TF_DOCS -->
