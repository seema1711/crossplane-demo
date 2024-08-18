#!/bin/bash

#Install helm
aws eks --region ap-south-1 update-kubeconfig --name platform-engg 
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

##Install the Crossplane Helm chart 
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

##dry-run
helm install crossplane \
crossplane-stable/crossplane \
--dry-run --debug \
--namespace crossplane-system \
--create-namespace

##install crossplane component
helm install crossplane \
crossplane-stable/crossplane \
--namespace crossplane-system \
--create-namespace

kubectl apply -f ./provider.yml

##secret
kubectl create secret \
generic aws-secret \
-n crossplane-system \
--from-file=creds=./aws-cred.txt



kubectl apply -f ./provider-config.yml




