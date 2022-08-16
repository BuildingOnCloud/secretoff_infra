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

resource "aws_ecs_service" "secretoff_service" {
  name            = "app_ecs-service1"
  cluster         = aws_ecs_cluster.secretoff_cluster.id
  task_definition = aws_ecs_task_definition.service_secretoff.arn
  desired_count   = 2
  load_balancer {
    target_group_arn = aws_lb_target_group.secretoff_target_security_group.arn
    container_name   = "app_container1"
    container_port   = 8080
  }
  network_configuration {
    subnets          = aws_subnet.private.*.id
    security_groups  = aws_security_group.lb.id
    assign_public_ip = true
  }
  deployment_circuit_breaker {
    enable = true
    rollback = false
  }
}
