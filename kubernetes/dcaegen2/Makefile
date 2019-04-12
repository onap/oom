make-dcaegen2: make-dcae-bootstrap make-dcae-cloudify-manager make-dcae-config-binding-service make-dcae-healthcheck make-dcae-redis make-dcae-servicechange-handler make-dcae-inventory-api make-dcae-deployment-handler make-dcae-policy-handler

make-dcae-bootstrap:
	cd charts && helm dep up dcae-bootstrap && helm lint dcae-bootstrap

make-dcae-cloudify-manager:
	cd charts && helm dep up dcae-cloudify-manager && helm lint dcae-cloudify-manager

make-dcae-config-binding-service:
	cd charts && helm dep up dcae-config-binding-service && helm lint dcae-config-binding-service

make-dcae-healthcheck:
	cd charts && helm dep up dcae-healthcheck && helm lint dcae-healthcheck

make-dcae-redis:
	cd charts && helm dep up dcae-redis && helm lint dcae-redis

make-dcae-servicechange-handler:
	cd charts && helm dep up dcae-servicechange-handler && helm lint dcae-servicechange-handler

make-dcae-inventory-api:
	cd charts/dcae-servicechange-handler/charts  && helm dep up dcae-inventory-api && helm lint dcae-inventory-api

make-dcae-deployment-handler:
	cd charts && helm dep up dcae-deployment-handler && helm lint dcae-deployment-handler

make-dcae-policy-handler:
	cd charts && helm dep up dcae-policy-handler && helm lint dcae-policy-handler
