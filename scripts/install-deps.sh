#!/bin/bash

HELM_DIR=k8s

install_tools() {
    sudo snap install yq
}

install_microk8s() {
    sudo snap install microk8s --classic --channel=1.32

    sudo usermod -a -G microk8s $USER

    mkdir -p ~/.kube

    sudo microk8s status --wait-ready

    echo "alias helm3='microk8s helm3'" >> ~/.bashrc
    echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc
}

install_load_balancer() {
    # refer: https://youtu.be/k8bxtsWe9qw?si=eMcjrNRLsyuD9mM5
    # he saved my day
    sudo microk8s kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml
    
    sudo microk8s kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v5.0.0/deploy/crds.yaml
    sudo microk8s helm3 install nginx-ingress oci://ghcr.io/nginx/charts/nginx-ingress --version 2.0.0
}

main() {
    install_tools

    install_microk8s

    install_load_balancer
}

main
