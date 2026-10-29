# Troubleshooting
Missing proxy: original deploy.sh never created a proxy, yet verified port 18083. Fix: ensure_proxy manages rolling-proxy2.
Ghost rolling-proxy: after reboot, old proxy storage was corrupted, rm failed, name still in use. Fix: use rolling-proxy2, never prune or system reset.
SELinux: mounted nginx -T failed Permission denied without label=disable, passed with it. Fix: always use --security-opt label=disable.
EXPOSE is only a label: image Ports 80/tcp does not mean the container listens on 80. Mounted config or port mapping decides the real port.
Jenkins user from /tmp: running jenkins podman commands from /root gives cannot chdir Permission denied. Fix: always cd /tmp first.
Root vs Jenkins storage: root Podman storage and Jenkins rootless storage are separate, do not mix their ps or images.
No restart policy: after reboot, rolling containers stop. Fix: podman start rolling-app-a rolling-app-b rolling-proxy2 from /tmp as jenkins, then curl verify.
Console sed quirk: Jenkins console shows sed without redirection, but local file has it and Test stage greps it. The file is the source of truth.
Build-context bug: rolling Build 5 failed because nginx.conf was never copied. Fix: PR 4 copies nginx.conf and uses --no-cache.
Shared tag namespace: standard and rolling jobs share image name and BUILD_NUMBER tags, so rolling tag 6 overwrote old standard tag 6. This is pipeline design, not a failure.
Build 6 root cause: repo nginx.conf has no conf.d include and its listen 8080 conflicts with Jenkins on host network. Fix: PR 5 port mapping for app slots.
Rollback caveat: rollback 18083 checks are non-fatal, so Rollback verified can print without a truly healthy service. Always verify with curls after rollback.
ensure_proxy mystery: ps checks pass interactively, yet Jenkins rollback reached podman run already in use. Cause unresolved, non-fatal because old proxy2 kept serving.
Port-forwarding loss: after Jenkins Build 7, ss showed only 18083, in-container curl still served Release 7. Fix: manual TAG=7 deploy restored listeners, always ss plus curl after a Jenkins rolling deploy.
Terraform 1.9.8 pinned, local-provider only, AWS folder code-only never applied. Ansible idempotence proven by Phase 5 re-run: ok=4, changed=0.
Long heredoc lesson: keep blocks short, never put code fences inside file content, never run a revert command in the same message as steps to follow.
Limits: 1.7 GB RAM, no live Kubernetes cluster, no live ELK, no live AWS, no trained AI model.
