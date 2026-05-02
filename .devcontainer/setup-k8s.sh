#!/bin/bash
set -e

until kubectl get nodes > /dev/null 2>&1; do sleep 1; done

echo "Installing Gateway API CRDs..."
# renovate: datasource=github-releases depName=gateway-api packageName=kubernetes-sigs/gateway-api extractVersion=^v(?<version>.+)$
GATEWAY_API_VERSION=1.2.1
kubectl apply -f "https://github.com/kubernetes-sigs/gateway-api/releases/download/v${GATEWAY_API_VERSION}/standard-install.yaml"

echo "Installing Cilium..."
NODE_IP=$(kubectl get node -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
helm repo add cilium https://helm.cilium.io/
helm repo update cilium
# renovate: datasource=helm depName=cilium packageName=cilium/cilium
CILIUM_VERSION=1.17.3
helm install cilium cilium/cilium \
  --version "${CILIUM_VERSION}" \
  --namespace kube-system \
  --set operator.replicas=1 \
  --set ipam.mode=kubernetes \
  --set kubeProxyReplacement=true \
  --set gatewayAPI.enabled=true \
  --set k8sServiceHost="${NODE_IP}" \
  --set k8sServicePort=6443

echo "Waiting for Cilium to be ready..."
kubectl wait --for=condition=Ready pod -l k8s-app=cilium -n kube-system --timeout=300s
kubectl wait --for=condition=Ready node --all --timeout=120s

echo "Installing ArgoCD..."
kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=Available deployment/argocd-server -n argocd --timeout=300s
