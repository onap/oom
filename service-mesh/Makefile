all: create_namespaces enable_istio_auto_inject install_keycloak install_auth_proxy install_cert_manager set_up_istio_config

create_namespaces:
	kubectl create namespace keycloak
	kubectl create namespace auth-proxy
	kubectl create namespace cert-manager

enable_istio_auto_inject:
	kubectl label namespace keycloak istio-injection=enabled

install_keycloak:
	helm repo add codecentric https://codecentric.github.io/helm-charts
	helm repo update
	helm install codecentric/keycloak --version 8.1.0 -n keycloak --namespace keycloak

install_auth_proxy:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update
	helm install bitnami/redis --set usePassword=false --name=auth --namespace auth-proxy --set persistence.enabled=false --set master.persistence.enabled=false --set slave.persistence.enabled=false

install_cert_manager:
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
	helm install --name cert-manager --namespace cert-manager --set installCRDs=true jetstack/cert-manager

set_up_istio_config:
	kubectl apply -f ./yamls/keycloak
	kubectl apply -f ./yamls/auth-proxy
	kubectl apply -f ./yamls/cert-manager
	kubectl apply -f ./yamls/istio-system
