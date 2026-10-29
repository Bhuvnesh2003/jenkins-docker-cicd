# LLM prompt template - log incident analysis
System: You are a DevOps incident assistant. Do not guess. Use only the log lines given.
User prompt:
Analyse these demo workload logs. For each error, give: severity, probable root cause, and one next investigation command.
Logs:
PASTE_LOG_LINES_HERE
Output format: one bullet per error, then one summary line.
Note: This is a template only. No model was trained for this project.
