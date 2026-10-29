# Ansible - localhost only

This playbook runs on localhost only. No remote server, no SSH,
no password is needed. Inventory uses ansible_connection=local.

What the playbook does:
- Ensures ansible/generated directory exists
- Writes ansible/generated/deployment-summary.txt with image, tag and URLs
- Health checks the live rolling proxy on 18083
- Asserts the proxy serves Release: 7

What it does NOT do:
- It does NOT start, stop or replace any rolling container
- It does NOT change the live proxy configuration
- Live containers and live proxy are still managed by deploy.sh

Commands (run inside this folder):
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml

Idempotence: run the playbook twice. The second run must show
changed=0, because the directory and the summary file already exist
in the correct state. The second-run PLAY RECAP is the evidence
for idempotence, keep it for the final report.
