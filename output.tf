output "ec2-public-ipaddr" {
    description = "link to ec2"
    value = format("ssh -i <ur key> ec2-user@ec2-%s.ap-south-1.compute.amazonaws.com",replace(aws_instance.ec2.public_ip,".","-"))
}
