# examples/easy/fargate-spot

In this example we'll instantiate a simple nginx webserver.
This example will run 2 fargate tasks, 1 will run on normal `FARGATE` (on-demand) and the other one will run on `FARGATE_SPOT` (spot).

This example will also create `vpc` and `security_group` to run fargate tasks.

To test that it's working:
1. Go to ECS Console
1. Find the created ECS cluster, click the cluster, you should see the cluster info screen
1. Click on the service
1. Go to `Tasks` tab
1. Click on one of the task
1. Find the public IP of the task
1. Try putting the IP to your browser, you should see nginx hello world screen


To check it's running on `FARGATE` or `FARGATE_SPOT`:

On the steps above on the same page where you find the public IP, you should be able to see the `CAPACITY_PROVIDER`
if it simply says `FARGATE` it means that the task is running on-demand and if it's `FARGATE_SPOT` it runs on fargate spot.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | ~> 2 |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| ecs\_cluster\_name | Name of the ECS Cluster created |
| ecs\_service\_name | Name of the ECS Service created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
