FROM mcr.microsoft.com/devcontainers/base:2.1.8-trixie@sha256:e389149057371298eaeb72e736fc2c4dcb79974de222dd471d2e6d675d2f61c4

RUN apt-get update && apt-get install -y apache2-utils && rm -rf /var/lib/apt/lists/*

# renovate: datasource=github-releases depName=kubectl packageName=kubernetes/kubernetes
ARG KUBECTL_VERSION=1.36.0
ENV KUBECTL_VERSION=${KUBECTL_VERSION}

RUN \
  if [ "${KUBECTL_VERSION}" != "none" ]; then \
    curl -fsSLo kubectl "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && curl -fsSLo kubectl.sha256 "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256" \
    && echo "$(awk '{print $1}' kubectl.sha256)  kubectl" | sha256sum -c - \
    && install kubectl /usr/local/bin \
    && rm kubectl kubectl.sha256; \
  fi

# renovate: datasource=github-releases depName=argocd packageName=argoproj/argo-cd
ARG ARGOCD_VERSION=3.3.9
ENV ARGOCD_VERSION=${ARGOCD_VERSION}

RUN \
  if [ "${ARGOCD_VERSION}" != "none" ]; then \
    curl -fsSLo argocd-linux-amd64 "https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64" \
    && install argocd-linux-amd64 /usr/local/bin/argocd \
    && rm argocd-linux-amd64; \
  fi

# renovate: datasource=github-releases depName=helm packageName=helm/helm
ARG HELM_VERSION=4.1.4
ENV HELM_VERSION=${HELM_VERSION}

RUN \
  if [ "${HELM_VERSION}" != "none" ]; then \
    curl -fsSLo helm.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    && tar -xzf helm.tar.gz --strip-components=1 linux-amd64/helm \
    && install helm /usr/local/bin/helm \
    && rm -rf helm helm.tar.gz; \
  fi

# renovate: datasource=github-releases depName=yamlfmt packageName=google/yamlfmt
ARG YAMLFMT_VERSION=0.21.0
ENV YAMLFMT_VERSION=${YAMLFMT_VERSION}

RUN \
  if [ "${YAMLFMT_VERSION}" != "none" ]; then \
    curl -fsSLo yamlfmt.tar.gz "https://github.com/google/yamlfmt/releases/download/v${YAMLFMT_VERSION}/yamlfmt_${YAMLFMT_VERSION}_Linux_x86_64.tar.gz" \
    && tar -xzf yamlfmt.tar.gz yamlfmt \
    && install yamlfmt /usr/local/bin/yamlfmt \
    && rm -f yamlfmt yamlfmt.tar.gz; \
  fi

# renovate: datasource=github-releases depName=gateway-api packageName=kubernetes-sigs/gateway-api
ARG GATEWAY_API_VERSION=1.2.1
ENV GATEWAY_API_VERSION=${GATEWAY_API_VERSION}

# renovate: datasource=helm depName=cilium registryUrl=https://helm.cilium.io/
ARG CILIUM_VERSION=1.19.3
ENV CILIUM_VERSION=${CILIUM_VERSION}

# renovate: datasource=helm depName=cert-manager registryUrl=https://charts.jetstack.io
ARG CERT_MANAGER_VERSION=1.14.4
ENV CERT_MANAGER_VERSION=${CERT_MANAGER_VERSION}
