
resource "aws_lb_target_group" "tg" {
  name     = "${var.ENV}-${var.COMPONENT}-tg"
  port     = var.APP_PORT //to check the health of the instances thats why we listener and tg ports are should same
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
}
resource "aws_lb_target_group_attachment" "tg-attach" {
  count            = length(aws_spot_instance_request.ec2-spot)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_spot_instance_request.ec2-spot.*.spot_instance_id[count.index]
  port             = var.APP_PORT
}

resource "aws_lb_listener" "alb-listener" {
  count             = var.LB_PUBLIC ? 1 : 0
  load_balancer_arn = data.terraform_remote_state.alb.outputs.alb_public_arn
  port              = var.APP_PORT
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener_rule" "static" {
  count        = var.LB_PRIVATE ? 1 : 0
  listener_arn = data.terraform_remote_state.alb.outputs.listner_private_arn
  priority     = var.LB_RULE_PRIORITY

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.roboshop.internal"]
    }
  }
}
