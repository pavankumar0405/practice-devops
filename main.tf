data "aws_vpc" "myvpc1" {
    default = true
}
resource "aws_security_group" "mysecgrp" {
    name = "myopen"
    description = "all net seg"
    vpc_id = data.aws_vpc.myvpc1.id
}
resource "aws_vpc_security_group_ingress_rule" "myingressrule" {
    security_group_id = aws_security_group.myopen.id
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cider_ipv4 = "0.0.0.0/0"
}
resource "aws_key_pair" "mykey" {
    key_name = "pkkey"
    public_key = file("~/.ssh/id_ed25519.pub")
}
resource "aws_vpc" "myec2" {
    ami = "ami-051a31ab2f4d498f5"
    instance_type = "t3.micro"
    key-pair = aws_key_pair.mykey.key_name
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.mysecgrp.id]
    tags = {
        Name = "myt-ec2"
    }
}