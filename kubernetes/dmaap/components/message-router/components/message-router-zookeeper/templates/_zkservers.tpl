{{/*
Create a server list string based on fullname, namespace, # of servers
in a format like "zkhost1:port:port;zkhost2:port:port"
*/}}
{{- define "zookeeper.serverlist" -}}
{{- $namespace := include "common.namespace" . }}
{{- $fullname := include "common.fullname" . -}}
{{- $name := include "common.name" . -}}
{{- $serverPort := .Values.service.serverPort -}}
{{- $leaderElectionPort := .Values.service.leaderElectionPort -}}
{{- $zk := dict "servers" (list) -}}
{{- range $idx, $v := until (int .Values.servers) }}
{{- $noop := printf "%s-%d.%s.%s.svc.cluster.local:%d:%d" $fullname $idx $name $namespace (int $serverPort) (int $leaderElectionPort) | append $zk.servers | set $zk "servers" -}}
{{- end }}
{{- printf "%s" (join ";" $zk.servers) | quote -}}
{{- end -}}