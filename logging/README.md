# Logging - demo workload (lightweight, no ELK live)
ELK live nahi chal raha hai, kyunki is host par 1.7 GB RAM hai.
Lightweight path: podman logs aur Jenkins console logs hi source hain.
Commands:
podman logs rolling-app-a | tail -50
podman logs rolling-app-b | tail -50
podman logs rolling-proxy2 | tail -50
Analysis: ai/analyze_logs.py se rule-based check karo.
Future ELK design: Filebeat -> Logstash -> Elasticsearch -> Kibana, sirf bade host par.
