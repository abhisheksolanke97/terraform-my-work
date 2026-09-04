resource "aws_vpc" "my_vpc" {
    cidr_block = 10.0.0.0/16
    tags = {
        Name = "my_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = 10.0.0.0/20 
    availability_zone = "us-west-2a" 
    map_public_ip_on_launch = true 
    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = 10.0.16.0/20 
    availability_zone = "us-west-2b"

    tags = {
        Name = "private_subnet"
    }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.my-vpc.id 

    tags = {
        Name = "IGW"
    }
}

resource "aws_eip" "nat_eip" {
    domain = "vpc" 
    tags = {
        Name = "nat_eip"
    }
}

resource "aws_nat_gateway" "nat" {
    subnet_id = aws_subnet.public_subnet.id 
    allocation_id = aws_eip.nat_eip.id
    tags = {
        Name = "nat"
    }
}