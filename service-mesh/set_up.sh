kubectl create namespace wordpress
kubectl create namespace serviceb
kubectl create namespace servicea

kubectl label namespace wordpress istio-injection=enabled
kubectl label namespace servicea istio-injection=enabled
kubectl label namespace serviceb istio-injection=enabled

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install bitnami/wordpress --version 9.3.3 -n wordpress --namespace wordpress

helm repo add ealenn https://ealenn.github.io/charts
helm install ealenn/echo-server --version 0.3.0 -n servicea --namespace servicea
helm install ealenn/echo-server --version 0.3.0 -n serviceb --namespace serviceb

kubectl apply -f ./yamls/servicea
kubectl apply -f ./yamls/serviceb
kubectl apply -f ./yamls/wordpress
