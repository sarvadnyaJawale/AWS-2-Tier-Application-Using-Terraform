# Target group
resource "aws_lb_target_group" "my_tg_a" { 
 name     = "target-group-a"
 port     = 80
 protocol = "HTTP"
 vpc_id   = var.vpc_id

   health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    protocol            = "HTTP"
  }
}
# Target group attachment
# By using Auto Scaling Groups, big organizations can dynamically manage and scale EC2 instances 

resource "aws_lb_target_group_attachment" "tg_attachment_a" {
 for_each         = { for idx, instance_id in var.ec2_instance_ids : idx => instance_id } #it was ran before using toset(var.instance_ids)
 target_group_arn = aws_lb_target_group.my_tg_a.arn
 target_id        = each.value
 port             = 80
}

# this approach will work meanwhile, make it more efficient, take list of ec2_ids from module/ec2/output.tf and then use it as input for alb

# resource "aws_lb_target_group_attachment" "tg_attachment_a" {
#  target_group_arn = aws_lb_target_group.my_tg_a.arn
#  target_id        = var.ec2_public_az1
#  port             = 80
# }

# resource "aws_lb_target_group_attachment" "tg_attachment_b" {
#  target_group_arn = aws_lb_target_group.my_tg_a.arn
#  target_id        = var.ec2_public_az2
#  port             = 80
# }

# alb
resource "aws_lb" "my_alb" {
 name               = "my-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [var.sg_http_ssh]
 subnets            = var.public_subnet

 tags = {
   Environment = "dev"
 }
}
// Listener
resource "aws_lb_listener" "my_alb_listener" {
 load_balancer_arn = aws_lb.my_alb.arn
 port              = "80"
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.my_tg_a.arn
 }
}
