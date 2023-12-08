[
    {
    "name"     : "backend-express",
    "essential" : true,
    "requiresCompatibilities" : "FARGATE",
    "user"      : "backend",
    "User"      : "backend",
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
    ]
  }
  ]