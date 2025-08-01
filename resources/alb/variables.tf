variable "name" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "app_port" {
  type = number
}