data "aws_availability_zones" "available" {
    state = "available"
}


resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags= {
        Name= "flask-vpc"
    }
}

resource "aws_subnet" "public" {
    count= 2 
    vpc_id = aws_vpc.main.id 
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4 , count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true

    tags= {
        Name= "flask_public_subnet_${count.index}"
    }
}


resource "aws_subnet" "private" {
    count= 2 
    vpc_id = aws_vpc.main.id 
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4 , count.index+2)
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags= {
        Name= "flask_private_subnet_${count.index}"
    }
}

resource "aws_internet_gateway" "aws_ig" {
    vpc_id = aws_vpc.main.id 

    tags = {
        Name= "flask_app_ig"
    }
}


resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block= "0.0.0.0/0"
        gateway_id= aws_internet_gateway.aws_ig.id
    }
    tags = {
        Name= "flask_route_table"
    }
}

resource "aws_route_table_association" "aws_rt_asso" {
    count=2
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.route_table.id 
}







