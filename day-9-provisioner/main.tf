resource "aws_instance" "example" {
    instance_type          = "t3.micro"
    ami                    = "ami-03db3415e6524c5d2"
    key_name               = "key0"
    count                  = 3
    vpc_security_group_ids = ["sg-087725dcecb9b6183"]

    provisioner "file" {
        source      = "hello.txt"
        destination = "/home/ec2-user/hello.txt"
    }

    provisioner "local-exec" {
        command = "echo ${self.private_ip} >> private_ips.txt"
    }

    connection {
        type          = "ssh"
        user          = "ec2-user"
        private_key   = file("${path.module}/key.pem")
        host          = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum install httpd -y",
            "sudo systemctl start httpd",
            "sudo systemctl enable httpd"
        ]
    }
}