resource "local_file" "deployment_info" {
  filename = "${path.module}/generated/deployment-info.txt"
  content  = <<-EOT
image = ${var.app_image}:${var.app_tag}
app_a_url = http://127.0.0.1:${var.app_a_port}/
app_b_url = http://127.0.0.1:${var.app_b_port}/
proxy_url = http://127.0.0.1:${var.proxy_port}/
EOT
}

resource "local_file" "proxy_upstream" {
  filename = "${path.module}/generated/proxy-upstream.conf"
  content  = <<-EOT
upstream app_backend {
    server 127.0.0.1:${var.app_a_port};
    server 127.0.0.1:${var.app_b_port};
}

server {
    listen ${var.proxy_port};

    location / {
        proxy_pass http://app_backend;
    }
}
EOT
}
