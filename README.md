# DLT-Log-Analyzer


Project Overview:
Create a Bash script that automates the process of analyzing Diagnostic Log and Trace (DLT) files. The script should provide functionalities to parse, filter, and summarize the log data, focusing on identifying common errors, warnings, and specific event occurrences within the log files.

Sample DLT Log Content:
Here’s an example of what the content of such a file might look like:

[2024-04-06 08:15:32] INFO System Startup Sequence Initiated
[2024-04-06 08:15:34] WARN Deprecated API usage detected: api_v1_backup
[2024-04-06 08:16:01] ERROR Unable to initialize network interface: eth0
[2024-04-06 08:16:05] INFO Network interface initialized successfully: eth1
[2024-04-06 08:17:42] DEBUG Process A started with PID: 1234
[2024-04-06 08:18:03] WARN Memory usage exceeds threshold: 85%
[2024-04-06 08:19:10] ERROR Disk write failure on device: /dev/sda1
[2024-04-06 08:20:00] INFO System health check OK
Project Requirements:
Log Parsing:
Extract key pieces of information from each log entry, such as timestamp, log level (INFO, WARN, ERROR, DEBUG), and the message.
Filtering:
Provide options to filter the log entries by log level. For example, a user might be interested only in ERROR and WARN level messages.
Error and Warning Summary:
Summarize errors and warnings, providing counts and details for each type encountered in the log.
Event Tracking:
Track specific events, such as "System Startup Sequence Initiated" and "System health check OK", to ensure critical processes are starting and completing as expected.
Report Generation:
Generate a report summarizing the findings, including any trends identified in the error/warning logs and the status of system events.
