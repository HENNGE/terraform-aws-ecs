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
| terraform | >= 0.12.26 |
| aws | >= 3.35.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.35.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_arn | ECS Cluster ARN to run ECS Task in | `string` | n/a | yes |
| container\_overrides | Overrides options of container. Expecting JSON. See https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_target.html#example-ecs-run-task-with-role-and-task-override-usage | `string` | `null` | no |
| fargate\_assign\_public\_ip | Assign Public IP or not to Fargate task, specify if `is_fargate` | `bool` | `false` | no |
| fargate\_security\_groups | Security groups to assign to Fargate task, specify if `is_fargate` | `list(string)` | `[]` | no |
| fargate\_subnets | Subnets to assign to Fargate task, specify if `is_fargate` | `list(string)` | `[]` | no |
| iam\_invoker | IAM ARN to invoke ECS Task | `string` | n/a | yes |
| is\_fargate | Task is fargate | `bool` | `false` | no |
| name | Name for scheduled action | `string` | n/a | yes |
| schedule\_description | The description of the rule | `string` | `"Cloudwatch event rule to invoke ECS Task"` | no |
| schedule\_rule | Schedule in cron or rate (see: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html for rules) | `string` | n/a | yes |
| task\_count | Desired ECS Task count to run | `number` | n/a | yes |
| task\_definition\_arn | Task definition ARN to run | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) of the rule. |

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

