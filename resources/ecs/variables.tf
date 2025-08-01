variable "cluster_name" {}
variable "task_family" {}
variable "cpu" {}
variable "memory" {}
variable "image" {}
variable "container_port" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "log_group_name" {}
variable "region" {}
variable "service_name" {}
variable "desired_count" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
variable "target_group_arn" {}

variable "secret_word" {
  description = "The SECRET_WORD to inject into the container"
  type        = string
}
