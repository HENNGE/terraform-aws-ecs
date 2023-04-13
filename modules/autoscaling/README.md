# autoscaling

Collection of terraform modules to configure ECS Service Autoscaling.

This module also includes Autoscaling Group (ASG) Scaling for easier autoscaling.

## Content

- `asg-target-tracking`
    - `ecs-reservations`
- `alb-target-tracking`
    - `target-requests-count`
    - `target-response-time`
- `ecs-target-tracking`
    - `service-utilization`
- `ecs-scheduled`


### Prerequisites

An ecs scalable target must be created in order to use majority of the modules.
Create ecs-autoscaling-target from `../core/ecs-autoscaling-target`


### `asg-target-tracking`

This module will scale EC2 Autoscaling Group (ASG) depending on certain metrics target.

|Submodule Name|Relevant ECS Target Metrics|
|---|---|
`ecs-reservations`| `CPUReservation` and/or `MemoryReservation`

Currently this module only have one submodule to scale in or out to keep certain number of ECS Cluster CPU / Memory Reservation value.


### `alb-target-tracking`

Autoscales ECS Service Desired Count according to specified Application Load Balancer Target Groups metrics value.
Submodules under this submodules are:

|Submodule Name|Relevant ALB Target Group metrics|
|---|---|
|`target-requests-count`|`Request Count Per Target`|
|`target-response-time`|`Target Response Time`|


### `ecs-target-tracking`

Autoscales ECS Service Desired count based on ECS Metrics itself.
Submodules under this submodules are:

|Submodule Name|Relevant ECS metrics|
|---|---|
`service-utilization`|ECS Service's `AverageCPUUtilization` and/or `AverageMemoryUtilization`


### `ecs-scheduled`

Autoscales ECS Service desired count on schedule.

## Module Naming Convention

```
autoscaling
    |- <main-target-of-interest>-<scaling-method>
        |- <monitored-metrics>-<metrics-of-interest>
    |- ...
```

Scaling methods are: `target-tracking`, `simple-scaling`, `step-scaling`.

Main Target of interest can be anything related to ecs such as ALB, ASG, etc.

Monitored metrics and metrics of interest can be anything inside the target of interest metrics / ECS metrics itself.

## Assumptions

- ECS Cluster has enough spare capacity to put more tasks
- These modules are applied after the stack is created (Plug-in style) (Note: applying at the same time with stack creation is currently not possible because module cannot have `depends_on` to other module)
- Lifecycle hook is applied to ASG for graceful shutdown from ECS Cluster (if using `asg-target-tracking/ecs-reservations` with `scale-in enabled`)

## Inputs
See each modules for inputs

## Output
See each modules for outputs

## Example

It's best to separate scaling policies in another file to not clutter the `main.tf`.
e.g. in file `scaling.tf`.

Assuming an application stack is already created in `main.tf` and appropriate values are outputted.


This example uses `alb-target-tracking/target-requests-count` as the autoscaling policy on ECS Service and `asg-target-tracking/ecs-reservations` to scale EC2 Autoscaling Group automatically.

```hcl
module "asg_scaling" {
  source           = "HENNGE/ecs/aws//modules/autoscaling/asg-target-tracking/ecs-reservation"
  version          = "1.0.0"

  name                         = "${local.prefix}-policy"
  autoscaling_group_name       = module.application_stack.asg_name
  ecs_cluster_name             = module.application_stack.ecs_cluster_name
  enable_cpu_based_autoscaling = true
  cpu_threshold                = 70
}

module "ecs_service_scaling_target" {
  source           = "HENNGE/ecs/aws//modules/core/ecs-autoscaling-target"
  version          = "1.0.0"

  ecs_cluster_name = module.application_stack.ecs_cluster_name
  ecs_service_name = module.application_stack.ecs_service_name
  min_capacity     = module.application_stack.ecs_service_desired_count
  max_capacity     = module.application_stack.ecs_service_desired_count * 2
}

module "ecs_service_scaling" {
  source  = "HENNGE/ecs/aws//modules/autoscaling/alb-target-tracking/target-requests-count"
  version = "1.0.0"

  name                        = "${local.prefix}-ecs-autoscaling"
  alb_arn_suffix              = module.application_stack.alb_arn_suffix
  target_group_arn_suffix     = module.application_stack.google_push_alb_target_group_arn_suffix
  scalable_target_resource_id = module.ecs_service_scaling_target.resource_id
  target_value                = 300
  scale_in_cooldown           = 30
  scale_out_cooldown          = 30
  disable_scale_in            = false
}
```

This example will create an autoscaling ASG and autoscaling ECS Service.


1st module will try to keep ECS CPU Reservation around 70% value, if additional tasks are launched, the autoscaling policy generated will automatically increase the ASG instances count to accommodate ECS expansion, and when tasks terminates, the autoscaling policy will shrink the ASG.


2nd and 3rd modules create an autoscaling service that scales-out when the traffic per tasks (or targets in `Target Group` terminology) reaches more than 300 requests / tasks.
It will wait for 30 seconds between scaling activity. It will try to scale-out to have 300 requests per target up to maximum of 2x the number of desired count specified in the ECS Service Definition.
When traffic is less than 300 per tasks, it'll bring down the number of tasks to no less than the original (before scale-out) ECS Service Desired Count.
