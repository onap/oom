{{- define "so.helpers.mariadbJdbcUrlBase" -}}
  {{- $replicaCount := default 3 .replicaCount -}}
  {{- $namespace := include "common.namespace" . -}}
  {{- $mariadbService :=  include "common.mariadbService" . -}}
  {{- printf "jdbc:mariadb:sequential://" -}}
  {{- range $mariadbcount, $e := until ($replicaCount|int) -}}
    {{- printf "%s-%s-%d.%s-headless:${DB_PORT}" $namespace $mariadbService $mariadbcount $mariadbService -}}
    {{- if lt $mariadbcount ( sub ($replicaCount|int) 1 ) -}}
      {{- printf "," -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
