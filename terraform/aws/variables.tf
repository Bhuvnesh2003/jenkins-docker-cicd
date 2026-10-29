variable "aws_region" {
  description = "AWS region for the example infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type for the example instance"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Replace with a real AMI ID from your own AWS account. No default is set on purpose, so this code cannot be applied by accident."
  type        = string
}
