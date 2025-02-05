output "ec2-public-ipaddr" {
    description = "link to ec2"
    value = "ec2-user@ec2-${aws_instance.ec2.public_ip}.ap-south-1.compute.amazonaws.com"
}
