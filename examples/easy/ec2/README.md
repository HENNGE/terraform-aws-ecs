# examples/easy/ec2

In this example we'll instantiate a simple nginx webserver.

Task networking mode in this example is `host` so that the port specified in `templates/container_definitions.tpl` will be bind.
Means there cannot be more than 1 task in an instance. Do experiment with dynamic port mapping with `bridge` network mode.

This example will also create `vpc` and `security_group` and `autoscaling group`.

Note: Instance profile is required for EC2 to connect to ECS Cluster. See [`modules/iam/ecs-instance-profile`](https://github.com/HENNGE/terraform-aws-ecs/tree/master/modules/iam/ecs-instance-profile).

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


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| aws | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | Override automatic detection of availability zones | `list(string)` | `[]` | no |
| enable\_ipv6 | Enable IPv6? | `bool` | `true` | no |
| instance\_profile\_arn | Instance Profile to use for EC2 to join to ECS Cluster. See `modules/iam/ecs-instance-profile` | `string` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


