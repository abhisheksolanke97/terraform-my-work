#!/bin/bash 
dnf update -y
dnf install -y 
systemctl start nginx 
systemctl enable nginx