output "ecr_repo_url"{
    value = aws_ecr_repository.ecr_repo.repository_url
}

output "alb_dns_name" {
    value = aws_lb.alb.dns_name
}

output "rds_endpoint" {
    value= aws_db_instance.rds_db.endpoint
}

output "ssh_command" {
  description = "Command to SSH into the EC2 instance"
  value       = "ssh -i ${aws_key_pair.ec2_key.key_name}.pem ubuntu@${aws_instance.ec2_instance.public_ip}"
}