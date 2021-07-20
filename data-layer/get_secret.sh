#!/bin/bash

export mariadbPassword=$(kubectl get secret --namespace default data-mariadb-galera-db-root-password -o jsonpath="{.data.password}" | base64 --decode)
envsubst < input_overrides.yaml > output_overrides.yaml