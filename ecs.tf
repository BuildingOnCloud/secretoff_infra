resource "aws_ecs_task_definition" "service_secretoff" {
  family = "service"
  name   = "task_def1"
  container_definitions = jsonencode([
    {
      name      = "app_ecs-service1"
      image     = "224270744698.dkr.ecr.us-east-1.amazonaws.com/app_registry1"
      cpu       = 1
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 80
        }
      ]
    }
  ])
}
