#loadbalancing main.tf

resource "aws_lb" "cf_lb" {
  name               = "cf-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_sg]
  subnets            = tolist(var.public_subnet)

  depends_on = [
    var.private_asg
  ]
}

resource "aws_lb_target_group" "cf_tg" {
  name     = "cf-lb-tg-${substr(uuid(), 0, 3)}"
  protocol = var.tg_protocol
  port     = var.tg_port
  vpc_id   = var.vpc_id
  
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 20
    interval            = 30
  }
  
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_lb_listener" "cf_lb_listener" {
  load_balancer_arn = aws_lb.cf_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cf_tg.arn
  }
}