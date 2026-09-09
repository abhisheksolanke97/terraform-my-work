resource "aws_instance" "ec2" {
    for_each = tomap({
        server-1 = "t3.micro"
        server-2 = "t3.small"
        server-3 = "c7i-flex.large"
    })
    ami = "ami-0bea529386a62a2ad"
    instance_type = echo.value 
    key_name = "key0" 
    tags = {
        Name = echo.key 
    }
}