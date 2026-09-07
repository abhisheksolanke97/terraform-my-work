resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr                   # VPC CREATED #
    tags = {
        Name = "my_vpc"
    }
}

resource "aws_subnet" "my_subnet" {
    vpc_id = aws_vpc.my_vpc.id                # public subnet created #
    cidr_block = var.public_subnet_cidr
    availability_zone = var.public_az 
    map_public_ip_on_launch = true 

    tags = {
        Name = "public_subnet"
    }
} 

resource "aws_subnet" "my_private_subnet" {
    vpc_id = aws_vpc.my_vpc.id                # private subnet created #
    cidr_block = var.private_subnet_cidr
    availability_zone = var.private_az
    
    tags = {
        Name = "private_subnet"
    }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.my_vpc.id                # internet gateway created #

    tags = {
        Name = "IGW"
    }
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"                            # elastic ip created #

    tags = {
        Name = "nat_eip"
    }
}

resource "aws_nat_gateway" "nat" {
    subnet_id = aws_subnet.public_subnet.id   # nat gateway created #
    allocation_id = aws_eip.nat_eip.id 

    tags = {
        Name = "nat"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id                # public route table created #

    route {
        gateway_id = aws_internet_gateway.IGW.id 
        cidr_block = "0.0.0.0/0"
    }

    tags = {
        Name = "public_rt"
    }
}

resource "aws_route_table_association" "public_rt_assoc" {
    subnet_id = aws_subnet.public_subnet.id                    # public route table association created #
    route_table_id = aws_route_table.public_rt.id 
}

resource "aws_route_table" "private_rt" {                  # private route table created #
    vpc_id = aws_vpc.my_vpc.id 

    route {
        nat_gateway_id = aws_nat_gateway.nat.id 
        cidr_block = "0.0.0.0/0"
    }

    tags = {
        Name = "private_rt"
    }
}

resource "aws_route_table_association" "private_rt_assoc" {
    subnet_id = aws_subnet.private_subnet.id                     # private route table association created #
    route_table_id = aws_route_table.private_rt.id 
}

resource "aws_security_group" "sg" {
    name = var.sg_name
    description = var.sg_name                   # security group created #
    vpc_id = aws_vpc.my_vpc.id 

    ingress {
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]                             
    }

    ingress {
        from_port = var.http_port
        to_port = var.http_port
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
        Name = "my-sg"
    }
}