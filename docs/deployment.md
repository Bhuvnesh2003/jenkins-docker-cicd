# Deployment
Rolling strategy is primary: app-a first, then app-b, proxy verified last on 18083.
Jenkins rolling job runs GitHub main, copies repo deploy.sh, runs it with IMAGE and TAG.
App slots use port mapping 127.0.0.1:18081:8080 and 127.0.0.1:18082:8080, proxy is host network on 18083.
Rollback: previous tag from last-good-tag, then both slots, then proxy check, which is non-fatal by design.
After any Jenkins rolling deploy, verify immediately with ss and curls on 18081, 18082, 18083.
After reboot: containers do not auto-start, start them from /tmp as jenkins, then curl verify.
Do not run extra Jenkins builds just for testing after final verification.
