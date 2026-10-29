output "demo_instance_id" {
  description = "ID of the example EC2 instance, only available after a real apply in your own AWS account"
  value       = aws_instance.demo.id
}
