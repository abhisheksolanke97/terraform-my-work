resource "aws_instance" "public_instance" {
    ami = "ami-0bea529386a62a2ad"
    instance_type = "t3.micro"
    key_name = "key0"
    count = 2
    vpc_security_group_ids = ["sg-087725dcecb9b6183"]
    tags = {
        Name = "public_instance"
    }
}