Module to generate IAM Instance Profile (and Role) for EC2 instances backing ECS Cluster.

* [Why do we need ECS instance policies?](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html) 
* [ECS roles explained](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_managed_policies.html)
* [More ECS policy examples explained](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/IAMPolicyExamples.html)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | Name prefix to be used on generated resources | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| iam\_instance\_profile\_id | Instance Profile id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


