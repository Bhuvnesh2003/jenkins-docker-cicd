variable "app_image" {
  description = "Demo workload container image built by Jenkins"
  type        = string
  default     = "docker.io/bhuvnesh15/jenkins-docker-cicd"
}

variable "app_tag" {
  description = "Demo workload image tag (Release number)"
  type        = string
  default     = "7"
}

variable "app_a_port" {
  description = "Host port for rolling app slot A"
  type        = number
  default     = 18081
}

variable "app_b_port" {
  description = "Host port for rolling app slot B"
  type        = number
  default     = 18082
}

variable "proxy_port" {
  description = "Host port for the rolling proxy"
  type        = number
  default     = 18083
}
