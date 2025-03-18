#!/bin/bash -e

MASTER_IP=$(hostname -I | awk '{print $2}')
pod_network_cidr=192.168.1.0/24

initialize_master_node ()
{
echo "[6] Initializing master node..."
echo "[6.1] Enabling kubelet service..."
sudo systemctl enable kubelet

echo "[6.2] Pulling Kubernetes images..."
sudo kubeadm config images pull

echo "[6.3] Initializing Kubernetes master node..."
sudo kubeadm init --apiserver-advertise-address=$MASTER_IP --pod-network-cidr=$pod_network_cidr --ignore-preflight-errors=NumCPU
}

configure_kubectl () 
{
echo "[7] Configuring kubectl..."
echo "[7.1] Configuring kubectl for root user..."
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[7.2] Configuring kubectl for vagrant user..."
mkdir -p /home/vagrant/.kube
sudo cp -f /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown 900:900 /home/vagrant/.kube/config
}

install_network_cni ()
{
echo "[8] Installing Calico network plugin..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
}

create_join_command ()
{
echo "[9] Creating join command for worker nodes..."
kubeadm token create --print-join-command | tee /vagrant/join_command.sh
chmod +x /vagrant/join_command.sh
}

initialize_master_node
configure_kubectl
install_network_cni
create_join_command