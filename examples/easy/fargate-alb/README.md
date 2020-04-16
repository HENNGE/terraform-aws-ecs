# examples/easy/fargate-alb

In this example we'll instantiate a simple nginx webserver placed behind an `Application Load Balancer`.

This example will also create `vpc`, `security_group`, and `alb`.

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

## Outputs

| Name | Description |
|------|-------------|
| load\_balancer\_dns | Accessible load balancer DNS |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
