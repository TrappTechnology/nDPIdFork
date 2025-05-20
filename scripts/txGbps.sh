#!/bin/bash

IFACE=enp2s0f0
echo "Measuring TX rate on interface $IFACE over 60 seconds..."

# Read initial value and timestamp
TX_START=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
T1=$(date +%s)

# Wait 60 seconds
sleep 60

# Read final value and timestamp
TX_END=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
T2=$(date +%s)

# Calculate byte difference and time difference
TX_BYTES=$((TX_END - TX_START))
TIME_DIFF=$((T2 - T1))

# Convert to bits per second, then Gbps
TX_GBPS=$(echo "scale=3; $TX_BYTES * 8 / $TIME_DIFF / 1000000000" | bc)

echo "TX over $TIME_DIFF seconds: $TX_BYTES bytes"
echo "TX Rate: $TX_GBPS Gbps"
