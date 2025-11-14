variable "ami_id" {
  description = "This is the ami id"
  type        = string
  default     = "ami-0ecb62995f68bb549"
}

variable "instance_type" {
  description = "This is the instance type in AWS"
  type        = string
  default     = "t3.micro"
}

variable "app_name" {
  type = string
  default = "Nodejs-server"
}

variable "vpc_id" {
  type = string
  default = "vpc-052228c3aa8df3be9"
}