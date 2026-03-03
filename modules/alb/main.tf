resource "aws_lb" "test" {
  name               = "jenkins-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id_lb]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Environment = "testing"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "targetgroup"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id 

  health_check {
    path                = "/login"
    port                = "8080"
    protocol            = "HTTP"
    matcher             = "200,403" 
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
}
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = var.instance
  port             = 8080
}
