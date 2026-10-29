# Terraform - demo workload (local only)

This folder manages the demo workload metadata with Terraform.
It does NOT build the application and it does NOT deploy to a cloud.

## What it uses

- Terraform 1.9.8 (pinned for this project, do not upgrade mid-project)
- Provider: hashicorp/local only
- No cloud provider, no cloud credentials, no AWS apply in this folder

## Commands (run inside this folder)

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve

Verified on this host: init successful, validate successful,
plan "2 to add, 0 to change, 0 to destroy", apply complete.

## What apply creates

- generated/deployment-info.txt: image, tag and the three URLs (18081, 18082, 18083)
- generated/proxy-upstream.conf: upstream app_backend (18081 + 18082), listen 18083, proxy_pass to app_backend

Important: the generated proxy file only mirrors the live proxy
configuration. It does NOT replace the live file at
/var/lib/jenkins/rolling-deploy/nginx/default.conf.
The live proxy (rolling-proxy2) is still managed by deploy.sh.

## AWS folder

aws/ is code-only example infrastructure. It is NOT initialized,
NOT planned and NOT applied on this host, because there is no real
AWS account or credentials here. Do not apply it without a real
AWS account. See aws/README.md.
