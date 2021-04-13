# scheduled-actions

### Requires aws provider version > 1.39

This module will run a specified task definition in ecs cluster in a cron-like manner.

Resources created by this module will be visible in AWS ECS console under `Scheduled Action` tab.
When the task is spawned by CloudWatch, the task will be visible in the `Task` tab and will have `events-rule/` prefix in `Started By` column.

This is not scheduled autoscaling. Make sure container terminates or this will pile tasks into the cluster.

## Components

Creates the following:
- CloudWatch Event Rule
- CloudWatch Event Target

## Launch Type

For the best result, just use same launch type as your service launch type.


## Example

```hcl
variables "iam_invoker" {
  description = "Invoker IAM Role, see below"
}
```

### Normal EC2 Launch Type

Assumptions:
- ECS has been set up properly, let's call the service as `ecs_cron_worker`

```hcl
module "ecs_worker_cron" {
  source  = "HENNGE/ecs/aws//modules/scheduled-actions"
  version = "1.0.0"

  name                 = "worker-cron"
  schedule_description = "Run this daily"
  schedule_rule        = "cron(0 9 * * ? *)"
  cluster_arn          = module.ecs_cluster.arn
  iam_invoker          = var.iam_invoker
  task_count           = 1
  task_definition_arn  = module.ecs_service.task_definition_arn
}
```

### Fargate Launch Type

```hcl
module "ecs_fargate_cron" {
  source  = "HENNGE/ecs/aws//modules/scheduled-actions"
  version = "1.0.0"

  name                 = "worker-fargate-cron"
  schedule_description = "Run this daily"
  schedule_rule        = "cron(0 9 * * ? *)"
  cluster_arn          = module.ecs_cluster.arn
  iam_invoker          = var.iam_invoker
  task_count           = 1
  task_definition_arn  = module.ecs_service.task_definition_arn
  
  is_fargate               = true
  fargate_assign_public_ip = true
  fargate_security_groups  = [module.instance_security_group.this_security_group_id]
  fargate_subnets          = module.vpc.public_subnets
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.35.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | ECS Cluster ARN to run ECS Task in | `string` | n/a | yes |
| <a name="input_container_overrides"></a> [container\_overrides](#input\_container\_overrides) | Overrides options of container. Expecting JSON. See https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_target.html#example-ecs-run-task-with-role-and-task-override-usage | `string` | `null` | no |
| <a name="input_fargate_assign_public_ip"></a> [fargate\_assign\_public\_ip](#input\_fargate\_assign\_public\_ip) | Assign Public IP or not to Fargate task, specify if `is_fargate` | `bool` | `false` | no |
| <a name="input_fargate_security_groups"></a> [fargate\_security\_groups](#input\_fargate\_security\_groups) | Security groups to assign to Fargate task, specify if `is_fargate` | `list(string)` | `[]` | no |
| <a name="input_fargate_subnets"></a> [fargate\_subnets](#input\_fargate\_subnets) | Subnets to assign to Fargate task, specify if `is_fargate` | `list(string)` | `[]` | no |
| <a name="input_iam_invoker"></a> [iam\_invoker](#input\_iam\_invoker) | IAM ARN to invoke ECS Task | `string` | n/a | yes |
| <a name="input_is_fargate"></a> [is\_fargate](#input\_is\_fargate) | Task is fargate | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for scheduled action | `string` | n/a | yes |
| <a name="input_schedule_description"></a> [schedule\_description](#input\_schedule\_description) | The description of the rule | `string` | `"Cloudwatch event rule to invoke ECS Task"` | no |
| <a name="input_schedule_rule"></a> [schedule\_rule](#input\_schedule\_rule) | Schedule in cron or rate (see: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html for rules) | `string` | n/a | yes |
| <a name="input_task_count"></a> [task\_count](#input\_task\_count) | Desired ECS Task count to run | `number` | n/a | yes |
| <a name="input_task_definition_arn"></a> [task\_definition\_arn](#input\_task\_definition\_arn) | Task definition ARN to run | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the rule. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## IAM Invoker
An IAM role is needed to invoke task from CloudWatch Event.

The template is as follows:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:RunTask"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": [
                "*"
            ],
            "Condition": {
                "StringLike": {
                    "iam:PassedToService": "ecs-tasks.amazonaws.com"
                }
            }
        }
    ]
}
```

This template is taken from `AWS managed policy`, the policy name is `AmazonEC2ContainerServiceEventsRole`

