# examples/easy/fargate

In this example we'll instantiate a simple nginx webserver

This example will also create `vpc` and `security_group` to run fargate tasks.

To test that it's working:
1. Go to ECS Console
1. Find the created ECS cluster, click the cluster, you should see the cluster info screen
1. Click on the service
1. Go to `Tasks` tab
1. Click on one of the task
1. Find the public IP of the task
1. Try putting the IP to your browser, you should see nginx hello world screen

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
| aws | >= 3.35.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.35.0 |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| ecs\_cluster\_name | Name of the ECS Cluster created |
| ecs\_service\_name | Name of the ECS Service created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
