resource "aws_lb" "alb" {
    load_balancer_type = "application"
    internal = false
    security_groups = [aws_security_group.alb_sg.id]
    subnets = aws_subnet.public[*].id
    
    tags = {
        Name= "flask_app_alb"
    }
}


resource "aws_lb_target_group" "alb_tg" {
    vpc_id= aws_vpc.main.id
    port=5000
    protocol= "HTTP"
    health_check { path = "/" }

    tags={
        Name= "flask_alb_tg"
    }

}

resource "aws_lb_listener" "tg_listener" {
    load_balancer_arn = aws_lb.alb.arn 
    port= 80
    protocol = "HTTP"
    default_action {
        type= "forward"
        target_group_arn = aws_lb_target_group.alb_tg.arn
    }
}