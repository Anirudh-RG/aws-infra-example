## Will contain aws tf for the following infra
1. a VPC with 2 subnets 1 public 1 priv
2. EC2 instances in both subnets(only in public for now)

## Issues
1. a default sec group gets crated and alloted to instance, yet to figure out & fix, u ll need to manually add routes for ICMP & All IPv4 to connect to your instance.
2. Output url is bugged, will fix soon, ip is right but format has tp be 192-168-.. , right now is 192.168
3. to connect better consult the instance dns name present on aws console

## Guide
files u ll need
1. .ssh dir with ur public & private keys, in file main.tf line 94
```
resource "aws_key_pair" "kpr" {
  key_name   = var.key_name
  public_key = file("./.ssh/id_rsa1.pub")  
}

```
replace file path with your public key

2. a file "providers.tf" in root of this project
sample file format is :
u need ur own creds in < >
```
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.35.0"
    }
  }
}

provider "aws" {
    region = var.asia-south
    profile = "<your profile set up on ur env where tf runs>"
    #config opts
}
```
3. Post these steps run the following commands:
- terraform init
- terraform plan
- terraform apply

post done make sure to run
- terraform destroy
