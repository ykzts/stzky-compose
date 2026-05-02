.PHONY: setup-apps deploy create-dev-secrets

setup-apps:
	@echo "Applying Application definitions..."
	kubectl apply -f k8s/apps/

create-dev-secrets:
	@echo "Creating development secrets..."
	bash scripts/create-dev-secrets.sh

deploy:
	@if [ -z "$(APP)" ]; then \
		echo "Error: Please specify APP. Example: make deploy APP=grafana"; \
		exit 1; \
	fi
	@echo "Updating dependencies for $(APP)..."
	helm dependency update k8s/$(APP)/
	@echo "Deploying $(APP)..."
	kubectl create namespace $(APP) --dry-run=client -o yaml | kubectl apply -f -
	helm template $(APP) k8s/$(APP)/ --namespace $(APP) | kubectl apply --server-side --force-conflicts -f -
