data "aws_vpc" "default" {
    default = true 
}

# CREATION OF SECURITY GROUPS 
resource "aws_security_group" "sg" {
    name = "my_sg"
    description = "my_sg"
    vpc_id = data.aws_vpc.default.id 

    ingress {
        from_port = 80
        to_port = 80 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0 
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        name = "my_tg"
    }
}

#CREATION OF LOAD BALANCER 
resource "aws_lb_target_group" "tg" {
    name = "tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id 
    health_check {
        path = "/" 
    }
}

resource "aws_lb" "lb" {
    name = "ALB"
    load_balancer_type = "application"
    subnets = ["subnet-0ff1392625e333bf4","subnet-0a9dcf0969af63047"]
    internal = false
    security_groups = [aws_security_group.sg.id]
}

resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn = aws_lb.lb.arn 
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forword"
        target_group_arn = aws_lb_target_group.tg.arn 
    }
}

#CREATE A AUTOSCALLING GROUP 
resource "aws_launch_template" "lt" {
    name_prefix = "web-template"
    image_id = "ami-0bea529386a62a2ad"
    key_name = "key0"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = filebase64("/root/terraform-my-work/day-3-lb-asg/user_data.sh")
}

resource "aws_autoscaling_group" "asg" {
    name = "ASG"
    desired_capacity = 2 
    min_size = 2
    max_size = 10
    target_group_arns = [aws_lb_target_group.tg.arn]
    vpc_zone_identifier = ["subnet-0ff1392625e333bf4","subnet-0a9dcf0969af63047"]
    launch_template {
        id = aws_launch_template.lt.id
        version = "$Latest"
    }
    health_check_type = "ELB"
}