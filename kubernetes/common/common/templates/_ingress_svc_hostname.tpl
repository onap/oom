{{- define "common.ingress.svchost" -}}
 	{{- $hostname := required "service hostname" .hostname -}}
	{{- $ingress_enabled := printf ".root.Values.config.useIngressHost.%s.enabled" $hostname -}}
	{{- if $ingress_enabled -}}
		{{- if .root.Values.global.ingress -}}
		{{- if .root.Values.global.ingress.virtualhost -}}
			{{- $domain := .root.Values.global.ingress.virtualhost.baseurl -}}
			{{- printf "%s.%s" $hostname $domain -}}
		{{- end -}}
		{{- end -}}
	{{- else -}}
		{{- $domain := include "common.namespace" .root -}}
		{{- printf "%s.%s" $hostname $domain -}}
	{{- end -}}
{{- end -}}
