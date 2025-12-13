resource "aws_ecr_repository" "ecr_repo" {
    name= "flask_app_ecr"
    image_tag_mutability = "MUTABLE"

    tags = {
        Name= "flask_app_ecr"
    }
}