# Requirments to set up a kubernetes Cluster ex. 1 master 2 Worker Nodes 
# update os repos on all nodes 
## Basically what is needed is the following 
### Required on all nodes 
- Installing Container runtime engine ” CRI-O or containerd ”
- Installing CNI ” container network Interface “
- Installing Kubernetes tools (kubeadm, kubelet, kubectl)
- Open 6443 port for communecation in firewall 
### Required on master Node
- Inintializing kubernetes controle plane node 
- After init is succesfull installing CNI ” container network Interface “
### Required on worker Nodes
- Joining the master node with the given command by the master.

## required in all nodes 
- setting up the vms for quality of life tools
```
sudo apt update \
sudo apt install -y net-tools \
git \
apt-transport-https \
ca-certificates \
curl \
gpg 

```
### installing a container run time ex. "CRI-O,containerd"
- after setting up the number of vms needed for this ex i am using just 3 vms 
```
# update packages in apt package manager
sudo apt update

# install containerd using the apt package manager
# containerd is lightwieght, reliable and fast (CRI native)
sudo apt-get install -y containerd

# create /etc/containerd directory for containerd configuration
sudo mkdir -p /etc/containerd

# Generate the default containerd configuration
# Change the pause container to version 3.10 (pause container holds the linux ns for Kubernetes namespaces)
# Set `SystemdCgroup` to true to use same cgroup drive as kubelet
containerd config default \
| sed 's/SystemdCgroup = false/SystemdCgroup = true/' \
| sed 's|sandbox_image = ".*"|sandbox_image = "registry.k8s.io/pause:3.10"|' \
| sudo tee /etc/containerd/config.toml > /dev/null

# Restart containerd to apply the configuration changes
sudo systemctl restart containerd

# Kubernetes doesn’t support swap 
sudo swapoff -a
```
### installing kubeadm tools ( kubeadm - kubelet - kubectl )
```
sudo mkdir -p -m 755 /etc/apt/keyrings

# download the k8s release gpg key FOR 1.33
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Download and convert the Kubernetes APT repository's GPG public key into
# a binary format (`.gpg`) that APT can use to verify the integrity
# and authenticity of Kubernetes packages during installation. 
# This overwrites any existing configuration in 
# /etc/apt/sources.list.d/kubernetes.list FOR 1.33 
# (`tee` without `-a` (append) will **replace** the contents of the file)
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# update packages in apt 
sudo apt-get update

apt-cache madison kubelet
apt-cache madison kubectl
apt-cache madison kubeadm


KUBE_VERSION="1.33.2-1.1"

# install kubelet, kubeadm, and kubectl at version 1.33.2-1.1
sudo apt-get install -y kubelet=$KUBE_VERSION kubeadm=$KUBE_VERSION kubectl=$KUBE_VERSION

# lock the pkgs version 
sudo apt-mark hold kubelet kubeadm kubectl
```
## REQUIRED ONLY ON MASTER 
```
sudo kubeadm init --pod-network-cidr=<cidr> --cri-socket=unix:///run/containerd/containerd.sock
```
```
# HOW TO RESET IF NEEDED
# sudo kubeadm reset --cri-socket=unix:///run/containerd/containerd.sock
# sudo rm -rf /etc/kubernetes /var/lib/etcd
```
- follow the instruction from kubeadm 

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
- after the nodes is joined in the cluster u have th choice of choosing the CNI u want to use in the cluster ex. (flannel, calcio...) follow inst. from websites ofc. 
```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml
```
