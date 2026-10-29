# AI-Powered E-Commerce DevOps Platform - Demo Workload
This project builds a DevOps delivery ecosystem around an existing static Nginx demo page.
It is NOT a real e-commerce shop. No real payments, database, or app features are in scope.
Live status: rolling Release 7 on 127.0.0.1:18081, 127.0.0.1:18082, and proxy 18083.
Host: RHEL 9.3, 2 CPU, about 1.7 GB RAM. Heavy live stacks are not run on this host.
Phase 1: Rolling deploy fix, rolling-proxy2, ensure_proxy, rollback test.
Phase 2: Jenkins CI/CD, Trivy HIGH/CRITICAL gate, GitHub PR 1 to 5, all merged.
Phase 3: Terraform local-provider only, AWS folder code-only, Ansible localhost.
Phase 4: Kubernetes manifests, Helm chart, Prometheus and Grafana configs, logging design, rule-based log script.
Phase 5: Docs, architecture diagram, evidence, and section 28 checklist.
Folders: terraform, ansible, kubernetes, helm, monitoring, logging, ai, docs.
Honesty limits: no live Kubernetes cluster, no live ELK, no live AWS apply, no trained AI model.
Trivy scope: HIGH and CRITICAL only, so 0 HIGH/CRITICAL does not mean 0 vulnerabilities overall.
Secret in kubernetes/secret.yaml is a dummy value only, never use it in production.
After reboot: start rolling-app-a, rolling-app-b, rolling-proxy2 from /tmp as jenkins, then curl 18081, 18082, 18083.
See docs/implementation.md, docs/deployment.md, docs/troubleshooting.md, and docs/section-28-checklist.md.
