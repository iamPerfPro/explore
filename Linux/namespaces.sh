#!/bin/bash

# Define the names of the namespaces and veth devices
NS1="ns1"
NS2="ns2"
VETH1="veth1"
VETH2="veth2"

# Define the IP addresses for the namespaces
IP1=""
IP2=""

# Create the namespaces
sudo ip netns add $NS1
sudo ip netns add $NS2

# Create the veth pair
sudo ip link add $VETH1 type veth peer name $VETH2

# Attach the veth devices to the namespaces
sudo ip link set $VETH1 netns $NS1
sudo ip link set $VETH2 netns $NS2

# Assign the IP addresses to the veth devices
sudo ip netns exec $NS1 ip addr add $IP1/24 dev $VETH1
sudo ip netns exec $NS2 ip addr add $IP2/24 dev $VETH2

# Bring up the veth devices
sudo ip netns exec $NS1 ip link set $VETH1 up
sudo ip netns exec $NS2 ip link set $VETH2 up

# Perform pings 
sudo ip netns exec $NS1 ping $IP2
sudo ip netns exec $NS2 ping $IP1 

