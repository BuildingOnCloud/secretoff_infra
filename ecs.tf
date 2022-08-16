resource "aws_ecs_task_definition" "service_secretoff" {
  family                   = "task_def1"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = "arn:aws:iam::224270744698:role/ecsTaskExecutionRole"
  container_definitions = jsonencode([
    {
      name      = "app_container1"
      image     = "224270744698.dkr.ecr.us-east-1.amazonaws.com/app_registry1"
      cpu       = 1
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}
