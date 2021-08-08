#!/bin/bash

export releaseName=$1

export mariadbSecretName=${releaseName}-mariadb-galera-db-root-password
envsubst < input-overrides.yaml > ../kubernetes/onap/resources/environments/data-overrides.yaml