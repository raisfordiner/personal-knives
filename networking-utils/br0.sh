sudo ip link add name br0 type bridge
sudo ip link set dev br0 up
sudo ip address add 10.10.39.11/8 dev br0
sudo ip route append default via 10.10.0.1 dev br0
sudo ip link set enp1s0 master br0
sudo ip a del 10.10.39.11/8 enp1s0
