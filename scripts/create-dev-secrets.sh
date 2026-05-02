#!/bin/bash
# Creates Kubernetes Secrets required for local development.
# All values default to development placeholders and can be overridden
# by setting the corresponding environment variables before running.
#
# Usage:
#   scripts/create-dev-secrets.sh
#   GRAFANA_DB_PASSWORD=mypass scripts/create-dev-secrets.sh
#   make create-dev-secrets

set -euo pipefail

# ---------------------------------------------------------------------------
# Defaults (override via environment variables)
# ---------------------------------------------------------------------------

# grafana-env (grafana namespace)
: "${GF_DATABASE_HOST:=grafana-postgresql:5432}"
: "${GF_DATABASE_NAME:=grafana}"
: "${GF_DATABASE_PASSWORD:=changeme}"
: "${GF_DATABASE_USER:=grafana}"
: "${GF_REMOTE_CACHE_CONNSTR:=addr=grafana-valkey-primary:6379}"
: "${GF_SMTP_FROM_ADDRESS:=noreply@example.com}"
: "${GF_SMTP_FROM_NAME:=Grafana}"
: "${GF_SMTP_HOST:=localhost:25}"
: "${GF_SMTP_PASSWORD:=}"
: "${GF_SMTP_USER:=}"
: "${ALLOY_PROMETHEUS_USERNAME:=admin}"
: "${ALLOY_PROMETHEUS_PASSWORD:=changeme}"

# prometheus-web-config (grafana namespace)
: "${PROMETHEUS_USERNAME:=admin}"
: "${PROMETHEUS_PASSWORD:=changeme}"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

apply() {
  kubectl apply -f -
}

ensure_namespace() {
  kubectl create namespace "$1" --dry-run=client -o yaml | apply
}

bcrypt_hash() {
  if command -v htpasswd > /dev/null 2>&1; then
    htpasswd -nbB "" "$1" | cut -d: -f2
  elif python3 -c "import bcrypt" > /dev/null 2>&1; then
    python3 -c "import bcrypt, sys; print(bcrypt.hashpw(sys.argv[1].encode(), bcrypt.gensalt(10)).decode())" "$1"
  else
    echo "Error: htpasswd (apache2-utils) or python3-bcrypt is required." >&2
    exit 1
  fi
}

# ---------------------------------------------------------------------------
# grafana namespace
# ---------------------------------------------------------------------------

ensure_namespace grafana

echo "Creating secret: grafana/grafana-env"
kubectl create secret generic grafana-env \
  --namespace grafana \
  --from-literal=GF_DATABASE_HOST="${GF_DATABASE_HOST}" \
  --from-literal=GF_DATABASE_NAME="${GF_DATABASE_NAME}" \
  --from-literal=GF_DATABASE_PASSWORD="${GF_DATABASE_PASSWORD}" \
  --from-literal=GF_DATABASE_USER="${GF_DATABASE_USER}" \
  --from-literal=GF_REMOTE_CACHE_CONNSTR="${GF_REMOTE_CACHE_CONNSTR}" \
  --from-literal=GF_SMTP_FROM_ADDRESS="${GF_SMTP_FROM_ADDRESS}" \
  --from-literal=GF_SMTP_FROM_NAME="${GF_SMTP_FROM_NAME}" \
  --from-literal=GF_SMTP_HOST="${GF_SMTP_HOST}" \
  --from-literal=GF_SMTP_PASSWORD="${GF_SMTP_PASSWORD}" \
  --from-literal=GF_SMTP_USER="${GF_SMTP_USER}" \
  --from-literal=ALLOY_PROMETHEUS_USERNAME="${ALLOY_PROMETHEUS_USERNAME}" \
  --from-literal=ALLOY_PROMETHEUS_PASSWORD="${ALLOY_PROMETHEUS_PASSWORD}" \
  --dry-run=client -o yaml | apply

echo "Creating secret: grafana/prometheus-web-config"
PROMETHEUS_HASH="$(bcrypt_hash "${PROMETHEUS_PASSWORD}")"
_tmpfile="$(mktemp)"
cat > "${_tmpfile}" <<EOF
basic_auth_users:
  ${PROMETHEUS_USERNAME}: ${PROMETHEUS_HASH}
EOF
kubectl create secret generic prometheus-web-config \
  --namespace grafana \
  --from-file=web-config.yml="${_tmpfile}" \
  --dry-run=client -o yaml | apply
rm -f "${_tmpfile}"

echo "Done."
