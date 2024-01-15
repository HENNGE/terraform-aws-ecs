[
  {
    "name": "${name}",
    "image": "nginx:latest",
    "cpu": ${cpu},
    "memory": ${memory},
    "memoryReservation": ${memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80
      }
    ]
  }
]
