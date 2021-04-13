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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | ~> 3 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | Override automatic detection of availability zones | `list(string)` | `[]` | no |
| enable\_ipv6 | Enable IPv6? | `bool` | `true` | no |
| instance\_profile\_arn | Instance Profile to use for EC2 to join to ECS Cluster. See `modules/iam/ecs-instance-profile` | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| load\_balancer\_dns | Accessible load balancer DNS |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


