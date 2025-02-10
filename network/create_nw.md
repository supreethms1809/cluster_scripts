# Create a LAN network

## System and Network details
### Login node: GPURTX6000-03-01-login
    - ip ext eth0:**dhcp or static ip for external internet access**
    - LAN ip eth1: 
        - IP 192.168.1.1
        - Port 24 (192.168.1.1/24)
        - Subnet Mask 255.255.255.0
    - 2 RTX 6000

### Node 1: GPUA30-02-01
    - ip ext eth0: N/A
    - LAN ip eth1: 
        - IP 192.168.1.2
        - Port 24 (192.168.1.2/24)
        - Subnet Mask 255.255.255.0
        - Gateway: 192.168.1.1 (Master's LAN IP)
        - DNS: 192.168.1.1 (Master's LAN IP)
    - 4 A30

### Node 2: GPUA30-02-02
    - ip ext eth0: N/A
    - LAN ip eth1: 
        - IP 192.168.1.3 
        - Port 24 (192.168.1.3/24)
        - Subnet Mask 255.255.255.0
        - Gateway: 192.168.1.1 (Master's LAN IP)
        - DNS: 192.168.1.1 (Master's LAN IP)
    - 4 A30

### Node 3: GPUA30-02-04
    - ip ext eth0: N/A
    - LAN ip eth1: 
        - IP 192.168.1.4
        - Port 24 (192.168.1.4/24)
        - Subnet Mask 255.255.255.0
        - Gateway: 192.168.1.1 (Master's LAN IP)
        - DNS: 192.168.1.1 (Master's LAN IP)
    - 8 A30

### Node 4: GPUGH200-02-05
    - ip ext eth0: N/A
    - LAN ip eth1: 
        - IP 192.168.1.5
        - Port 24 (192.168.1.5/24)
        - Subnet Mask 255.255.255.0
        - Gateway: 192.168.1.1 (Master's LAN IP)
        - DNS: 192.168.1.1 (Master's LAN IP)
    - 8 H100

### Memory: parallel file system with NAS
    - need to check if its possible

## Network Configuration
1. On Master node, edit `vim /etc/network/interfaces`
```
# Master (eth0 - Internet)
auto eth0
iface eth0 inet static
    address Your_Public_IP
    netmask Your_Public_Subnet_Mask
    gateway Your_ISP's_Gateway
    dns-nameservers Your_ISP's_DNS_Servers

# Master (eth1 - LAN)
auto eth1
iface eth1 inet static
    address 192.168.1.1
    netmask 255.255.255.0
```

2. On Compute node, edit `vim /etc/network/interfaces`
```
# Compute Node (example)
auto eth0
iface eth0 inet static
    address 192.168.1.2
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 192.168.1.1
```

## IP Forwarding and Network Address Translation (NAT) on Master node (to allow compute nodes to access the internet through it)
On master node
```
# Enable IP forwarding (persist across reboots)
sudo sysctl -w net.ipv4.ip_forward=1
sudo nano /etc/sysctl.conf  # Add the line: net.ipv4.ip_forward=1
sudo nano /etc/sysctl.d/ipforward.conf # Add the line: net.ipv4.ip_forward=1

# Configure NAT (using iptables)
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE # Added for clarity
sudo iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT

# Save iptables rules (persist across reboots)
sudo iptables-save > /etc/iptables/rules.v4  # Or use your distribution's method

# Restore iptables rules on boot (add to /etc/rc.local or similar)
# Example: iptables-restore < /etc/iptables/rules.v4
```

## SSH access on compute nodes
- Generate ssh keys `ssh-keygen` on all nodes
- Copy public key to compute nodes
    - From master node, use `ssh-copy-id username@node_ip`
        - `ssh-copy-id root@192.168.1.x` or check if we can use other <usernames>
        - x = compute node number
    - Check passwordless access to each compute node

## Slurm installation
Refer slurm installation guide for more details