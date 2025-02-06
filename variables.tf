variable "asia-south" {
  description = "sets the def region to ap-south-1"
  type = string
  default = "ap-south-1"
}

variable "availability_zones" {
  description = "List of available Availability Zones in a region"
  type        = list(string)
  default     = [
    "ap-south-1a",
    "ap-south-1b"
    # only these two because t2.micro doesn't exist in ap-south-1c
  ]
}

variable "key_name" {
  description = "The name of the SSH key pair to access the EC2 instance"
  type        = string
  default     = "kp-terraform"  
}