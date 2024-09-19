# Variables
DOCKER_IMAGE = digitify
DOCKER_TAG = latest
DOCKER_REPO = fan0o

# Default target: show help
.PHONY: help
help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

# Docker commands
docker-build: ## Build the Docker image without cache
	docker build . -t $(DOCKER_IMAGE):$(DOCKER_TAG) --no-cache

docker-run: ## Run the Docker container on port 8080
	docker run -d --name $(DOCKER_IMAGE) -p 8080:8080 $(DOCKER_IMAGE):$(DOCKER_TAG)

docker-tag: ## Tag the Docker image for the repository
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_REPO)/$(DOCKER_IMAGE):$(DOCKER_TAG)

docker-push: ## Push the Docker image to the repository
	docker push $(DOCKER_REPO)/$(DOCKER_IMAGE):$(DOCKER_TAG)

docker-build-push: docker-build docker-tag docker-push ## Build, tag, and push the Docker image

# k3s installation
install-k3s: ## Install k3s and configure KUBECONFIG
	curl -sfL https://get.k3s.io | sh -
	if [ -z "$$KUBECONFIG" ]; then \
		echo "KUBECONFIG not set. exporting..."; \
		sudo chmod 644 /etc/rancher/k3s/k3s.yaml; \
		export KUBECONFIG=/etc/rancher/k3s/k3s.yaml; \
		env | grep KUBECONFIG; \
		kubectl get ns; \
		echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc; \
	fi
	echo -e "k3s installed successfully"

# Helm commands
#helm-create: ## Create a Helm chart called digitify
#	helm create digitify

install-helm-chart: ## Install or upgrade the Helm chart
	helm upgrade --install digitify --namespace digitify -f ./helm/digitify/values.yaml ./helm/digitify/

uninstall-helm-chart: ## Uninstall the Helm release
	helm uninstall digitify -n digitify

# Port forwarding
port-forward: ## Forward port 8000 to 8080 for digitify service
	kubectl port-forward svc/digitify 8080:8080 -n digitify

setup-ingress-cert:
	kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/v3.6.2/deploy/crds.yaml
	kubectl create ns nginx-ingress
	helm install ingress-controller oci://ghcr.io/nginxinc/charts/nginx-ingress --version 1.3.2 -n nginx-ingress
	helm repo add jetstack https://charts.jetstack.io --force-update
	helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.15.3 --set crds.enabled=true
	echo "Creating self-signed cluster-issuer..."
	until cat <<EOYAML | kubectl apply -f -
	apiVersion: cert-manager.io/v1
	kind: ClusterIssuer
	metadata:
	name: selfsigned-cluster-issuer
	spec:
	selfSigned: {}
	EOYAML
	do sleep 1; done
	kubectl --timeout=10s wait --for=condition=Ready clusterissuers.cert-manager.io selfsigned-cluster-issuer

# .PHONY declarations
.PHONY: docker-build docker-run docker-tag docker-push docker-build-push install-k3s helm-create install-helm-chart uninstall-helm-chart port-forward setup-ingress-cert

