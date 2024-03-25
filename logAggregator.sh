#!/bin/bash

DB_FILE="$HOME/Documents/logs/firewalld.db"

sqlite3 $DB_FILE <<EOF
CREATE TABLE IF NOT EXISTS blocked (
    timestamp TEXT,
    blocked_type TEXT,
    network_in TEXT,
    mac TEXT,
    src TEXT,
    dst TEXT,
    port TEXT,
    protocol TEXT
);
EOF

journalctl -k --since "100 seconds ago" | grep -E "_DROP|_REJECT" | while read -r line; do
    timestamp=$(echo "$line" | grep -o '\[[^]]*\]' | sed 's/\[\(.*\)\]/\1/')
    blocked_type=$(echo "$line" | grep -oE '_REJECT|_BLOCK')
    network_in=$(echo "$line" | grep -o 'IN=[^ ]*' | cut -d= -f2)
    mac=$(echo "$line" | grep -o 'MAC=[^ ]*' | cut -d= -f2)
    src=$(echo "$line" | grep -o 'SRC=[^ ]*' | cut -d= -f2)
    dst=$(echo "$line" | grep -o 'DST=[^ ]*' | cut -d= -f2)
    port=$(echo "$line" | grep -o 'DPT=[^ ]*' | cut -d= -f2)
    protocol=$(echo "$line" | grep -o 'PROTO=[^ ]*' | cut -d= -f2)
    
    sqlite3 $DB_FILE <<EOF
    INSERT INTO blocked (timestamp, blocked_type, network_in, mac, src, dst, port, protocol)
    VALUES ('$timestamp', '$blocked_type', '$network_in', '$mac', '$src', '$dst', '$port', '$protocol');
EOF
done