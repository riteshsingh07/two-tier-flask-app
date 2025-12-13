resource "aws_key_pair" "ec2_key" {
    key_name = "tf_ec2_key"
    public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJuzZ3VTvSb4DlKeeLfUTdvx2+W6kNsfxX6RvbCoA3J5 riteshsingh@Riteshs-MacBook-Air.local"

}


resource "aws_instance" "ec2_instance" {
    ami = "ami-02b8269d5e85954ef"
    instance_type = "m7i-flex.large"
    key_name= aws_key_pair.ec2_key.key_name 
    subnet_id = aws_subnet.public[0].id
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    associate_public_ip_address = true 

    user_data = file("user_data.sh")

    root_block_device {
        volume_size = 8
        volume_type = "gp3"
    }

    tags = {
        Name= "tf_flask_app"
    }
}
