# #!/bin/bash

# # Set to the eth0 IP (must not be 127.0.0.1)
# SERVER_IP="10.31.1.157"
# BANDWIDTH="1G"
# DURATION=10

# # Bind the client to the eth0 IP as source (to force using eth0)
# SOURCE_IP="$SERVER_IP"

# echo "Starting iperf3 UDP test to $SERVER_IP for $DURATION seconds at $BANDWIDTH from $SOURCE_IP..."

# iperf3 -c "$SERVER_IP" -u -B "$SOURCE_IP" -b "$BANDWIDTH" -t "$DURATION"

# echo "Test completed."

#!/bin/bash

# Set to the eth0 IP (must not be 127.0.0.1)
#!/bin/bash

# Set to the eth0 IP (must not be 127.0.0.1)
#!/bin/bash

# Set to the eth0 IP (must not be 127.0.0.1)
SERVER_IP="10.31.1.157"
BANDWIDTH="1G"
DURATION=10

# Bind the client to the eth0 IP as source (to force using eth0)
SOURCE_IP="$SERVER_IP"

echo "Starting iperf3 UDP test to $SERVER_IP for $DURATION seconds at $BANDWIDTH from $SOURCE_IP..."

# Run iperf3 and capture output
OUTPUT=$(iperf3 -c "$SERVER_IP" -u -B "$SOURCE_IP" -b "$BANDWIDTH" -t "$DURATION")

# Print full output
echo "$OUTPUT"

# Extract packets sent from sender summary line
PACKETS_SENT=$(echo "$OUTPUT" | grep -Eo '[0-9]+/[0-9]+.*sender' | head -n1 | awk -F'/' '{print $2}' | awk '{print $1}')

echo "Packets sent: $PACKETS_SENT"
echo "Test completed."


