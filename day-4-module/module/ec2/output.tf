output "public_ip" {
    value aws_instance.public_instance.public.ip
}

output "private_ip" {
    value = aws_instance.private_instance.private.ip
}
