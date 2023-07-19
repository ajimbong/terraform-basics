resource "aws_lb" "alb" {
  name               = "trust-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.pub-sn1.id, aws_subnet.pub-sn2.id]
  depends_on = [ aws_vpc.vpc, aws_nat_gateway.ngw1, aws_nat_gateway.ngw2, aws_internet_gateway.igw, aws_route_table.prv-rt1,  aws_route_table.prv-rt2 ]
}

resource "aws_lb_target_group" "alb-tg" {
  name     = "trust-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_listener" "alb-https-listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl-cert-arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

resource "aws_lb_listener" "alb-http-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}



# Creating the auto-scaling group
resource "aws_launch_configuration" "launch-config" {
  name                 = "Trust - Web Server Config"
  image_id             = var.ec2-ami
  instance_type        = var.ec2-instance-type
  security_groups      = [aws_security_group.webserver-sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2-s3-access-profile.name
  key_name = var.ec2-keypair

  user_data = <<-EOF
    #!/bin/bash 
    sudo su 
    yum update -y 
    yum install httpd -y 
    chkconfig httpd on 
    cd /var/www/html 
    aws s3 sync s3://trust-s3-website /var/www/html 
    service httpd start
  EOF
}

resource "aws_autoscaling_group" "asg" {
  name                      = "Trust ASG"
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  #wait_for_elb_capacity     = 2
  depends_on = [ aws_vpc.vpc, aws_nat_gateway.ngw1, aws_nat_gateway.ngw2, aws_internet_gateway.igw, aws_route_table.prv-rt1,  aws_route_table.prv-rt2 ]
  

  # Attaching to target group
  target_group_arns = [aws_lb_target_group.alb-tg.arn]

  # Specifying the launch config
  launch_configuration = aws_launch_configuration.launch-config.name

  # Specifying the subnets
  vpc_zone_identifier = [aws_subnet.prv-sn1.id, aws_subnet.prv-sn2.id]

  tag {
    key                 = "Name"
    value               = "Trust Web Server"
    propagate_at_launch = true
  }

}