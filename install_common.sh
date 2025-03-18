#!/bin/bash -e

KUBERNETES_VERSION=1.30
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install common - "$IP

install_required_packages ()
{
echo "[1] Installing required packages..."
echo "[1.1] Updating package list and installing required packages..."
sudo apt update
sudo apt -y install curl apt-transport-https vim git curl wget

echo "[1.2] Downloading Kubernetes apt key and adding Kubernetes apt repository..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "[1.3] Installing Kubernetes components..."
sudo apt update
sudo apt -y install kubelet kubectl kubeadm

echo "[1.4] Holding Kubernetes components to prevent automatic updates..."
sudo apt-mark hold kubelet kubeadm kubectl
}

configure_hosts_file ()
{
echo "[2]: add host name for ip"
host_exist=$(cat /etc/hosts | grep -i "$IP" | wc -l)
if [ "$host_exist" == "0" ];then
echo "$IP $HOSTNAME " >> /etc/hosts
fi
}


disable_swap () 
{
echo "[3] Disabling swap..."
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
}

configure_sysctl ()
{
echo "[4] Configuring sysctl settings for Kubernetes..."
sudo tee /etc/modules-load.d/k8s.conf<<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
}

install_docker_runtime () 
{
echo "[5] Installing Docker runtime..."
echo "[5.1] Adding Docker's official GPG key..."
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "[5.2] Adding Docker apt repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[5.3] Updating package list with Docker repository and installing containerd"
sudo apt update
sudo apt install -y containerd

echo "[5.4] Configuring containerd..."
mkdir -p /etc/containerd
containerd config default | sed -e "s#SystemdCgroup = false#SystemdCgroup = true#g" | tee /etc/containerd/config.toml

echo "[5.6] Restarting and enabling containerd service..."
systemctl restart containerd
systemctl enable containerd

echo "[5.7] Holding containerd to prevent automatic updates..."
apt-mark hold containerd
}

install_required_packages
configure_hosts_file
disable_swap
configure_sysctl
install_docker_runtime