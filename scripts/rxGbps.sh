#!/bin/bash

IFACE=enp2s0f0

rx1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
tx1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
t1=$(date +%s)

sleep 30  # You can change this to 10 or 60 for longer interval

rx2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
tx2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
t2=$(date +%s)

rx_diff=$((rx2 - rx1))
tx_diff=$((tx2 - tx1))
time_diff=$((t2 - t1))

rx_gbps=$(echo "scale=3; $rx_diff * 8 / $time_diff / 1000000000" | bc)
tx_gbps=$(echo "scale=3; $tx_diff * 8 / $time_diff / 1000000000" | bc)

echo "Interface: $IFACE"
echo "RX Rate: $rx_gbps Gbps"
echo "TX Rate: $tx_gbps Gbps"
