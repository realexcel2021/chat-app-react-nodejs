[
    {
    "name"     : "backend-express",
    "essential" : true,
    "requiresCompatibilities" : "FARGATE",
    "image" : "${image}",
    "portMappings" : [
    {
        "containerPort" : 3000,
        "hostPort"      : 3000
    }
    ],
    "secrets" : [
    {
        "name" : "MONGO_URL",
        "valueFrom" : "${secret_value}"
    }
    ],
    "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "us-west-2",
                "awslogs-create-group": "true",
                "awslogs-stream-prefix": "firelens"
            }
  }
}
]