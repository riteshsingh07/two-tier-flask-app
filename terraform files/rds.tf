resource "aws_db_subnet_group" "db_subnet" {
    name= "db_subnet_group"
    subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_instance" "rds_db" {
    engine = "mysql"
    engine_version = "8.0.43"
    instance_class= "db.t4g.micro"
    allocated_storage = 20
    identifier = "flask-app-rds"
    db_name = "devops"
    username = "admin"
    password = "admin0406"
    db_subnet_group_name = aws_db_subnet_group.db_subnet.name
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    parameter_group_name = "default.mysql8.0"
    publicly_accessible = false
    skip_final_snapshot = true 

    tags = {
        Name= "flask_app_rds"
    }

}