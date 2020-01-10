#!/bin/bash

echo 'ECS_CLUSTER=${ecs_cluster}' >> /etc/ecs/ecs.config
start ecs
