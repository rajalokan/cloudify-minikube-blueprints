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
curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o /tmp/minikube-linux-amd64
sudo install /tmp/minikube-linux-amd64 /usr/bin/minikube

minikube start

# # Start minikube
ctx logger info "Starting Minikube"
# export MINIKUBE_WANTUPDATENOTIFICATION=false
# export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME/.minikube
export CHANGE_MINIKUBE_NONE_USER=true
mkdir -p $HOME/.kube || true
touch $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

# # Fix in kubeadm
# echo '1' | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables

# Start minikube
sudo -E minikube start --vm-driver=none
# sudo -E minikube addons enable dashboard

minikube status
kubectl cluster-info

mkdir -p ~/k8s/nginx
cat <<EOM >~/k8s/nginx/deployment.yaml
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
EOM

kubectl apply -f deployment.yaml
kubectl get deployments
kubectl describe deployment nginx-deployment
kubectl get pods -l app=nginx
# kubectl describe pod <pod-name>



# kubectl run hello-minikube --image=k8s.gcr.io/echoserver:1.10 --port=8080
# kubectl expose deployment hello-minikube --type=NodePort
# kubectl get pod
# minikube service hello-minikube --url
# curl $(minikube service hello-minikube --url)
#
# sudo chown -R $USER $HOME/.minikube
#
# ctx logger info "Bootstrap Successful"
#
# # sudo mv /root/.kube $HOME/.kube \
# #     && sudo chown -R $USER $HOME/.kube \
# #     && sudo chgrp -R $USER $HOME/.kube
# # sudo mv /root/.minikube $HOME/.minikube \
# #
# #     && sudo chgrp -R $USER $HOME/.minikube
#
# # sudo chown -R $USER: $HOME/.minikube
