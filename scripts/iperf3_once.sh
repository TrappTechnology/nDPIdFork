
# SERVER_IP="10.31.1.157"
# BANDWIDTH="1G"
# DURATION=10

# # Bind the client to the eth0 IP as source (to force using eth0)
# SOURCE_IP="$SERVER_IP"

# echo "Starting iperf3 UDP test to $SERVER_IP for $DURATION seconds at $BANDWIDTH from $SOURCE_IP..."

# # Run iperf3 and capture output
# OUTPUT=$(iperf3 -c "$SERVER_IP" -u -B "$SOURCE_IP" -b "$BANDWIDTH" -t "$DURATION")

# # Print full output
# echo "$OUTPUT"

# # Extract packets sent from sender summary line
# PACKETS_SENT=$(echo "$OUTPUT" | grep -Eo '[0-9]+/[0-9]+.*sender' | head -n1 | awk -F'/' '{print $2}' | awk '{print $1}')

# echo "Packets sent: $PACKETS_SENT"
# echo "Test completed."

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

# Extract packets sent from summary line
PACKETS_SENT=$(echo "$OUTPUT" | grep 'sender' | tail -n1 | grep -oP '\d+/\K\d+')

# Extract transfer value and unit from summary line (not per second lines)
TRANSFER_LINE=$(echo "$OUTPUT" | grep 'sender' | tail -n1)
NUM=$(echo "$TRANSFER_LINE" | awk '{print $7}')
UNIT=$(echo "$TRANSFER_LINE" | awk '{print $8}')

# Convert to bytes
case "$UNIT" in
  Bytes) BYTES_SENT=$(printf "%.0f" "$NUM") ;;
  KBytes) BYTES_SENT=$(printf "%.0f" "$(echo "$NUM * 1024" | bc)") ;;
  MBytes) BYTES_SENT=$(printf "%.0f" "$(echo "$NUM * 1024 * 1024" | bc)") ;;
  GBytes) BYTES_SENT=$(printf "%.0f" "$(echo "$NUM * 1024 * 1024 * 1024" | bc)") ;;
  *) BYTES_SENT="Unknown unit: $UNIT" ;;
esac

echo "Packets sent: $PACKETS_SENT"
echo "Total bytes sent: $BYTES_SENT"
echo "Test completed."



