#!/bin/bash
publicip="138.2.120.162"
privateip="10.0.0.124"



sudo kubeadm init --pod-network-cidr=192.168.0.0/16 \
    --apiserver-advertise-address=${privateip}\
    --control-plane-endpoint=${privateip}\
    --apiserver-cert-extra-sans=${privateip},${publicip}



mkdir -p $HOME/.kube
sudo rm -f $HOME/.kube/config
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo cp -i /etc/kubernetes/admin.conf ./



curl https://projectcalico.docs.tigera.io/manifests/calico.yaml -O
kubectl apply -f calico.yaml



sudo systemctl stop kubelet
sudo iptables --flush
sudo iptables -tnat --flush
sudo systemctl start kubelet



