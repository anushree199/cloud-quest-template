variable "name"                  {}
variable "vpc_cidr"              {}
variable "public_subnet_cidr"    {}
variable "availability_zone"     {}
variable "app_port"              {}
variable "ecr_name" {}
variable "ecs_cluster_name" {}
# variable "subnet_ids" {
#   type = list(string)
# }

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "task_family" {
  description = "Family name for the task definition"
  type        = string
}

variable "cpu" {
  description = "CPU units for the task"
  type        = string
}

variable "memory" {
  description = "Memory (MiB) for the task"
  type        = string
}

variable "image" {
  description = "Docker image to use in container"
  type        = string
}

variable "container_port" {
  description = "Port container listens on"
  type        = number
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
}

variable "security_group_ids" {
  description = "Security groups to assign to ECS tasks"
  type        = list(string)
}

variable "secret_word" {
  description = "The SECRET_WORD to inject into the container"
  type        = string
}
