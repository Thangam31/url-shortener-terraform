variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "url-shortener"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for app (private) subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "data_subnet_cidrs" {
  description = "CIDR blocks for data (private) subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to use"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
  default     = "url-shortener-key"
}

variable "nat_instance_type" {
  description = "Instance type for the NAT instance"
  type        = string
  default     = "t3.micro"
}

variable "app_instance_type" {
  description = "Instance type for app instances"
  type        = string
  default     = "t3.micro"
}



variable "app_ami_id" {
  description = "AMI ID for app instances"
  type        = string
  default     = "ami-0037855f86d0a04b4"
}


