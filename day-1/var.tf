variable "ami" {
    default = "ami-0bea529386a62a2ad"
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