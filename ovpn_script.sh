#!/bin/bash
trap '' 2

# Stop shill and restart it with a nicer attitude towards tun0
sudo stop shill
sudo start shill BLOCKED_DEVICES=tun0

# Sleep 10 seconds to allow chromebook to reconnect to the network
sudo sleep 10
sudo openvpn --mktun --dev tun0
sudo sleep 3

# Add google DNS on top of current ones, since openvpn command does not do it
#sudo sed -i '1s/^/# new DNS\nnameserver 8.8.8.8\nnameserver 8.8.4.4\n# old DNS\n/' /var/run/shill/resolv.conf

# Lauch openvpn, finally...
sudo openvpn --config <paste your Open VPN config here>.ovpn --dev tun0

# When ctrl-c is hit remove tun0 and cleanup the DNS
sudo openvpn --rmtun --dev tun0
#sudo sed -i '/# new DNS/,/# old DNS/d' /var/run/shill/resolv.conf
trap 2
