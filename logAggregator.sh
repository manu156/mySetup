journalctl -k --since "10 seconds ago" | grep -E "_DROP|_REJECT" >> ~/Documents/logs/firewallBlocked.log
