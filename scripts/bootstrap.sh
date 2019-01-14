#! /bin/bash -e

ctx logger info "Bootstrapping Minikube"
sudo apt install -y wget || sudo yum install -y wget

if [[ ! -f /tmp/sclib.sh ]]; then
    wget -q https://raw.githubusercontent.com/rajalokan/okanstack/master/sclib.sh -O /tmp/sclib.sh
fi
source /tmp/sclib.sh

# Preconfigure the instance
_preconfigure_instance minikube

# Install docker runtime container
ctx logger info "Installing docker"
run_ansible_role docker

# Install kubectl
ctx logger info "Installing kubectl"
sudo bash -c 'cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF'
sudo yum install -y kubectl

# Install minikube
ctx logger info "Installing Minikube"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start minikube
    # export MINIKUBE_WANTUPDATENOTIFICATION=false
    # export MINIKUBE_WANTREPORTERRORPROMPT=false
    # export MINIKUBE_HOME=$HOME
    # export CHANGE_MINIKUBE_NONE_USER=true
    # mkdir $HOME/.kube || true
    # touch $HOME/.kube/config
    # export KUBECONFIG=$HOME/.kube/config

ctx logger info "Starting Minikube"
sudo minikube start --vm-driver=none
