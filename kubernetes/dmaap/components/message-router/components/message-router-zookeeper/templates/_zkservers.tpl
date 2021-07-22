{{/*
Create a server list string based on fullname, namespace, # of zookeeperServers
in a format like "zkhost1:port:port;zkhost2:port:port"
*/}}
{{- define "zookeeper.serverlist" -}}
{{- $namespace := include "common.namespace" . }}
{{- $fullname := include "common.fullname" . -}}
{{- $name := include "common.name" . -}}
{{- $serverPort := .Values.service.serverPort -}}
{{- $leaderElectionPort := .Values.service.leaderElectionPort -}}
{{- $zk := dict "zookeeperServers" (list) -}}
{{- range $idx, $v := until (int .Values.zookeeperServers) }}
{{- $noop := printf "%s-%d.%s.%s.svc.cluster.local:%d:%d" $fullname $idx $name $namespace (int $serverPort) (int $leaderElectionPort) | append $zk.zookeeperServers | set $zk "zookeeperServers" -}}
{{- end }}
{{- printf "%s" (join ";" $zk.zookeeperServers) | quote -}}
{{- end -}}