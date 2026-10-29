# Architecture - Demo Workload
GitHub main -> Jenkins jobs (DevSecOps, Standard, Rolling)
Jenkins -> Podman build with no-cache -> Trivy HIGH/CRITICAL gate
Jenkins Rolling -> deploy.sh -> rolling-app-a (18081) and rolling-app-b (18082)
rolling-app-a and rolling-app-b -> rolling-proxy2 (18083) -> User
Terraform local -> generated deployment-info and proxy-upstream files (mirror only)
Ansible local -> health check 18083 and Release 7 assert
Kubernetes and Helm -> code only, no live cluster
Prometheus and Grafana -> configs only, no live server
Logs -> podman logs -> ai/analyze_logs.py rule-based analysis
