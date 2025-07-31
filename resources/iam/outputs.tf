# output "execution_role_arn" {
#   value = aws_iam_role.execution_role.arn
# }

# output "task_role_arn" {
#   value = aws_iam_role.task_role.arn
# }

# output "role_arn" {
#   value = aws_iam_role.eks.arn
# }


output "execution_role_arn" {
  description = "ARN of ECS Task Execution Role"
  value       = aws_iam_role.execution_role.arn
}

output "task_role_arn" {
  description = "ARN of ECS Task Role"
  value       = aws_iam_role.task_role.arn
}
