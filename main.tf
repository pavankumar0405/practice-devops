data "aws_vpc" "myvpc1" {
    default = true
}
resource "aws_security_group" "mysecgrp" {
    name = "myopen"
    description = "all net seg"
    vpc_id = data.aws_vpc.myvpc1.id
}
resource "aws_vpc_security_group_ingress_rule" "myingressrule" {
    security_group_id = aws_security_group.mysecgrp.id
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_key_pair" "mykey" {
    key_name = "pkkey"
    public_key = file("~/id_ed25519.pub")
}
resource "aws_instance" "myec2" {
    ami = "ami-019715e0d74f695be"
    instance_type = "t3.micro"
    key_name = aws_key_pair.mykey.key_name
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.mysecgrp.id]
    tags = {
        Name = "myt-ec2"
    }
}