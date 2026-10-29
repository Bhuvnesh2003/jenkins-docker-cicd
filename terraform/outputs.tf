output "app_image_tag" {
  description = "Demo workload image and tag"
  value       = "${var.app_image}:${var.app_tag}"
}

output "app_a_url" {
  description = "Rolling app slot A URL"
  value       = "http://127.0.0.1:${var.app_a_port}/"
}

output "app_b_url" {
  description = "Rolling app slot B URL"
  value       = "http://127.0.0.1:${var.app_b_port}/"
}

output "proxy_url" {
  description = "Rolling proxy URL"
  value       = "http://127.0.0.1:${var.proxy_port}/"
}

output "deployment_info_file" {
  description = "Generated deployment info file"
  value       = local_file.deployment_info.filename
}

output "proxy_upstream_file" {
  description = "Generated proxy upstream config file"
  value       = local_file.proxy_upstream.filename
}
