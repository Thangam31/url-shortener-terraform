variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "app_subnet_ids" { type = list(string) }
variable "target_group_arn" { type = string }
variable "alb_security_group_id" { type = string }
variable "key_name" { type = string }
variable "app_instance_type" { type = string }
variable "app_ami_id" { type = string }
