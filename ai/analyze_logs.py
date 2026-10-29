import sys
RULES = [
    ("502", "CRITICAL", "Proxy up hai, backend down ya listener nahi hai", "curl 127.0.0.1:18081 && curl 127.0.0.1:18082 && ss -tln | grep 1808"),
    ("Connection refused", "CRITICAL", "Target port par koi process listen nahi kar raha", "ss -tln | grep 1808 && podman ps -a"),
    ("Permission denied", "HIGH", "Mount ya SELinux ne access roka ho sakta hai", "podman logs rolling-proxy2 | tail -20"),
    ("404", "MEDIUM", "Galat path ya missing file", "curl -i 127.0.0.1:18083/"),
    ("500", "HIGH", "Backend me internal error", "podman logs rolling-app-a | tail -20"),
]
def main():
    source = sys.argv[1] if len(sys.argv) > 1 else "/dev/stdin"
    with open(source) as f:
        lines = f.readlines()
    found = 0
    for line in lines:
        line = line.strip()
        if not line:
            continue
        for pattern, severity, cause, command in RULES:
            if pattern in line:
                found += 1
                print("MATCH: " + pattern)
                print("SEVERITY: " + severity)
                print("CAUSE: " + cause)
                print("NEXT: " + command)
                print("LINE: " + line)
                print("---")
                break
    if found == 0:
        print("No known error pattern found.")
    print("Total matches: " + str(found))
if __name__ == "__main__":
    main()
