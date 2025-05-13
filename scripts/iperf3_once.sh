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

# Extract and sum packets from per-second stats (5th column)
PACKETS_SENT=$(echo "$OUTPUT" | awk '/sec/ && $0 ~ /Datagrams/ { sum += $(NF); } END { print sum }')

echo "Packets sent1: $PACKETS_SENT"
echo "Test completed."


