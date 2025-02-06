resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Main" = "Main-VPC"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "192.168.0.0/20"
  availability_zone = var.availability_zones[0] #work-around
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Public-Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "192.168.16.0/20"
  availability_zone = var.availability_zones[0] #work-around
  tags = {
    "Name" = "Private-Subnet"
  }
}

resource "aws_route_table" "default-rtb-private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "192.168.0.0/16"
    gateway_id = "local"  
  }
}

resource "aws_route_table" "pub-route-table" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    
}

resource "aws_route_table_association" "public-association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.pub-route-table.id
}

resource "aws_route_table_association" "private-association" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.default-rtb-private.id
}

resource "aws_security_group" "sg-allow_ssh" {
    vpc_id = aws_vpc.main.id
    name = "allow-ssh"
    description = "allows ssh traffic"
    tags = {
      "Name" = "allow-ssh"
    }
}

resource "aws_vpc_security_group_ingress_rule" "ALLOW-SSH" {
  security_group_id = aws_security_group.sg-allow_ssh.id
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = "22"
  to_port = "22"
}
resource "aws_vpc_security_group_egress_rule" "out_allow_all" {
  security_group_id = aws_security_group.sg-allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_instance" "ec2" {
  ami = "ami-05fa46471b02db0ce" # check your ami by going to aws console,in the region u want to
  associate_public_ip_address = true
  availability_zone           = aws_subnet.public_subnet.availability_zone
  key_name                   = aws_key_pair.kpr.key_name
  subnet_id                  = aws_subnet.public_subnet.id
  instance_type              = "t2.micro"
  vpc_security_group_ids     = [ aws_security_group.sg-allow_ssh.id ] 
    
  tags = {
    "key" = "my-ec2-instance"
  }
}

resource "aws_key_pair" "kpr" {
  key_name   = var.key_name
  public_key = file("./.ssh/id_rsa1.pub")  
}