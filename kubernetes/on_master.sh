#!/usr/bin/env bash
echo " updating repos registery"

sudo apt update 
echo "installing important pkgs"
sudo apt install -y net-tools \
git \
ssh \
apt-transport-https \
ca-certificates \
curl \
gpg
echo "updating repos registery"
sudo apt update 
echo "installing and configure containerd"
sudo apt-get install -y containerd 
sudo mkdir -p /etc/containerd
containerd config default \
| sed 's/SystemdCgroup = false/SystemdCgroup = true/' \
| sed 's|sandbox_image = ".*"|sandbox_image = "registry.k8s.io/pause:3.10"|' \
| sudo tee /etc/containerd/config.toml > /dev/null
echo "restarting containerd"
sudo systemctl restart containerd
echo "turning of swap memory"
sudo swapoff -a
sudo mkdir -p -m 755 /etc/apt/keyrings
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

apt-cache madison kubelet
apt-cache madison kubectl
apt-cache madison kubeadm
KUBE_VERSION="1.33.2-1.1"
echo "installing kube tools"
sudo apt-get install -y kubelet=$KUBE_VERSION kubeadm=$KUBE_VERSION kubectl=$KUBE_VERSION
sudo apt-mark hold kubelet kubeadm kubectl
echo "enabling ip forwarding"
sudo sysctl -w net.ipv4.ip_forward=1
sudo sed -i '/^#net\.ipv4\.ip_forward=1/s/^#//' /etc/sysctl.conf
sudo sysctl -p

#only should be on master
echo "init k8s master"
sudo kubeadm init --pod-network-cidr=10.0.0.0/16 --cri-socket=unix:///run/containerd/containerd.sock > k8s.txt
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
cat /home/k8s.txt 
exit 0