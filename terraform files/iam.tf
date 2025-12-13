resource "aws_iam_role" "ec2_iam_role" {
    name= "flask_ec2_iam_role"

    assume_role_policy = jsonencode(
        {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
)

}

resource "aws_iam_role_policy_attachment" "admin_access" {
    role       = aws_iam_role.ec2_iam_role.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "flask_ec2_iam_role"
    role = aws_iam_role.ec2_iam_role.name
}