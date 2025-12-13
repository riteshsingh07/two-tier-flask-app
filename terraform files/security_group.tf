resource "aws_security_group" "alb_sg" {
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 80
        to_port = 80
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
        Name= "flask_alb_sg"
    }
}



resource "aws_security_group" "ec2_sg" {
    vpc_id = aws_vpc.main.id



    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH Open"
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP Open"
}

    ingress {
        from_port= 5000
        to_port= 5000
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
        description = "ALB to ECS"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
    
    tags = {
        Name= "flask_ecs_sg"
    }

}


resource "aws_security_group" "rds_sg" {
    vpc_id= aws_vpc.main.id

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.ec2_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name= "flask_rds_sg"
    }
}