# examples/complete-ecs

This example will create a hybrid ECS stack with both EC2 and Fargate launch type.
Both services will be linked to an application load balancer and will run nginx container.
Also this example will include request count per target autoscaling strategy (see `modules/autoscaling/alb-target-tracking/target-requests-count`) to demonstrate the ECS Autoscaling.

ASG will also autoscale using `modules/autoscaling/asg-target-tracking/ecs-reservation`.
At the moment this example is written, support for `capacity_provider` is still not that great.

This example will also create `vpc`, `security_group`, and `alb`.

## Testing
This will create `<alb_dns_name>/ec2` and `<alb_dns_name>/fargate` that will route the requests to either tasks running on ec2 or fargate.

To test autoscaling, use `ab`, autoscaling will kick in if there's sustained requests for at least 3 minutes.

`ab -t 300 http://<alb_dns_name>/ec2`

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) |  >= 3.74.0  |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | 5.13.0 |
| <a name="module_alb_security_group"></a> [alb\_security\_group](#module\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_asg"></a> [asg](#module\_asg) | terraform-aws-modules/autoscaling/aws | ~> 7.0 |
| <a name="module_asg_autoscaling"></a> [asg\_autoscaling](#module\_asg\_autoscaling) | ../../modules/autoscaling/asg-target-tracking/ecs-reservation | n/a |
| <a name="module_easy_ec2"></a> [easy\_ec2](#module\_easy\_ec2) | ../../modules/simple/ec2 | n/a |
| <a name="module_easy_fargate"></a> [easy\_fargate](#module\_easy\_fargate) | ../../modules/simple/fargate | n/a |
| <a name="module_ec2_service_autoscaling_target"></a> [ec2\_service\_autoscaling\_target](#module\_ec2\_service\_autoscaling\_target) | ../../modules/core/ecs-autoscaling-target | n/a |
| <a name="module_ec2_target_request_autoscaling"></a> [ec2\_target\_request\_autoscaling](#module\_ec2\_target\_request\_autoscaling) | ../../modules/autoscaling/alb-target-tracking/target-requests-count | n/a |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | ../.. | n/a |
| <a name="module_ecs_security_group"></a> [ecs\_security\_group](#module\_ecs\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_fargate_service_autoscaling_target"></a> [fargate\_service\_autoscaling\_target](#module\_fargate\_service\_autoscaling\_target) | ../../modules/core/ecs-autoscaling-target | n/a |
| <a name="module_fargate_target_request_autoscaling"></a> [fargate\_target\_request\_autoscaling](#module\_fargate\_target\_request\_autoscaling) | ../../modules/autoscaling/alb-target-tracking/target-requests-count | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_lb_listener_rule.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.fargate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
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
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


