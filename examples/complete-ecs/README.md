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


