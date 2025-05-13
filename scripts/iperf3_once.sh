#!/bin/bash

# Set to the eth0 IP (must not be 127.0.0.1)
SERVER_IP="10.31.1.157"
BANDWIDTH="1G"
DURATION=10

# Bind the client to the eth0 IP as source (to force using eth0)
SOURCE_IP="$SERVER_IP"

echo "Starting iperf3 UDP test to $SERVER_IP for $DURATION seconds at $BANDWIDTH from $SOURCE_IP..."

iperf3 -c "$SERVER_IP" -u -B "$SOURCE_IP" -b "$BANDWIDTH" -t "$DURATION"

echo "Test completed."
