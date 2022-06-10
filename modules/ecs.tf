resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "task_definition"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions = jsonencode([{
    name        = "container"
    image       = var.ecr_repository_url
    essential   = true
    cpu         = var.container_cpu
    memory      = var.container_memory

    portMappings = [
      {
        containerPort = var.app_port
        hostPort      = var.app_port
      }
    ]
  }])

}

resource "aws_ecs_service" "service" {
  name            = "service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = local.count_service
  launch_type     = "EC2"

  #network_configuration {
   # security_groups  = [aws_security_group.ecs_sg.id]
   # subnets          = aws_subnet.private_subnet.*.id
   # assign_public_ip = true
  #}

  #load_balancer {
  #  target_group_arn = aws_alb_target_group.web_server.arn
  #  container_name   = "container"
  #  container_port   = var.app_port
  #}

  #depends_on = [aws_alb_listener.http, aws_iam_role_policy_attachment.ecsTaskExecutionRole_policy]
}