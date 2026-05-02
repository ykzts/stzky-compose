#!/bin/bash
set -e

until kubectl get nodes > /dev/null 2>&1; do sleep 1; done

if [ -n "${GATEWAY_API_VERSION}" ] && [ "${GATEWAY_API_VERSION}" != "none" ]; then
  echo "Installing Gateway API CRDs (v${GATEWAY_API_VERSION})..."
  kubectl apply -f "https://github.com/kubernetes-sigs/gateway-api/releases/download/v${GATEWAY_API_VERSION}/standard-install.yaml"
else
  echo "Skipping Gateway API CRDs installation (GATEWAY_API_VERSION is not set or none)."
fi

if [ -n "${CILIUM_VERSION}" ] && [ "${CILIUM_VERSION}" != "none" ]; then
  echo "Installing Cilium (v${CILIUM_VERSION})..."
  echo "Waiting for node InternalIP to be assigned..."
  until NODE_IP=$(kubectl get node -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}' 2>/dev/null) && [ -n "${NODE_IP}" ]; do sleep 1; done
  helm repo add cilium https://helm.cilium.io/
  helm repo update cilium
  helm upgrade --install cilium cilium/cilium \
    --version "${CILIUM_VERSION}" \
    --namespace kube-system \
    --set operator.replicas=1 \
    --set ipam.mode=kubernetes \
    --set kubeProxyReplacement=true \
    --set gatewayAPI.enabled=true \
    --set k8sServiceHost="${NODE_IP}" \
    --set k8sServicePort=6443 \
    --set cgroup.autoMount.enabled=false

  echo "Waiting for Cilium to be ready..."
  kubectl wait --for=condition=Ready pod -l k8s-app=cilium -n kube-system --timeout=300s
  kubectl wait --for=condition=Ready node --all --timeout=120s
else
  echo "Skipping Cilium installation (CILIUM_VERSION is not set or none)."
fi

if [ -n "${CERT_MANAGER_VERSION}" ] && [ "${CERT_MANAGER_VERSION}" != "none" ]; then
  echo "Installing cert-manager (v${CERT_MANAGER_VERSION})..."
  helm repo add jetstack https://charts.jetstack.io
  helm repo update jetstack
  helm upgrade --install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --version "${CERT_MANAGER_VERSION}" \
    --set installCRDs=true

  echo "Waiting for cert-manager to be ready..."
  kubectl wait --for=condition=Ready pod -l app.kubernetes.io/instance=cert-manager -n cert-manager --timeout=120s
else
  echo "Skipping cert-manager installation (CERT_MANAGER_VERSION is not set or none)."
fi

if [ -n "${ARGOCD_VERSION}" ] && [ "${ARGOCD_VERSION}" != "none" ]; then
  echo "Installing ArgoCD (v${ARGOCD_VERSION})..."
  kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
  kubectl apply -n argocd --server-side --force-conflicts -f "https://raw.githubusercontent.com/argoproj/argo-cd/v${ARGOCD_VERSION}/manifests/install.yaml"

  kubectl wait --for=condition=Available deployment/argocd-server -n argocd --timeout=300s
else
  echo "Skipping ArgoCD installation."
fi
