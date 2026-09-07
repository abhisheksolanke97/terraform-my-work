output "public_ip" {
    value = aws_instance.public_instance.public_ip
}

output "priavte_ip" {
    value = aws_instance.private_instance.private_ip
}
