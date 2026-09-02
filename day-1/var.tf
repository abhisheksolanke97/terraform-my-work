variable "ami" {
    default = "ami-090d68841c2a28756"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "key_name" {
    default = "key0"
}

variable "volume_size" {
    default = 10 
}

variable "volume_type" {
    default = "gp3"
}