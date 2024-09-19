variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_name" {
  type    = string
  default = "demo_vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
    "private_subnet_3" = 3
  }
}

variable "public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3
  }
}
variable "environment" {
  description = "Environment for deployment"
  type        = string
  default     = "dev"
}

variable "variables_sub_cidr" {
  description = "CIDR Block for the Variables Subnet"
  type        = string
  default     = "10.0.202.0/24"
}

variable "variables_sub_az" {
  description = "Availability Zone used for Variables Subnet"
  type        = string
  default     = "us-west-2a"
}

variable "variables_sub_auto_ip" {
  description = "Set Automatic IP Assigment for Variables Subnet"
  type        = bool
  default     = true
}

variable "phone_number" {
  type      = string
  sensitive = true
}

variable "us-west-2-azs" {
  type = list(string)
  default = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c",
    "us-west-2d",
    "us-west-2e"
  ]
}

variable "ip" {
  type = map(string)
  default = {
    prod = "10.0.150.0/24"
    dev  = "10.0.250.0/24"
  }
}

variable "env" {
  type = map(any)
  default = {
    prod = {
      ip = "10.0.150.0/24"
      az = "us-west-2a"
    }
    dev = {
      ip = "10.0.250.0/24"
      az = "us-west-2e"
    }
  }
}

