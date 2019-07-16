{{- define "common.sidecar.alias" -}}
  {{- if .Values.global.installSidecarSecurity }}
hostAliases:
- ip: {{ .Values.global.aaf.serverIp }}
  hostnames:
  - {{ .Values.global.aaf.serverHostname }}
  {{- end }}
{{- end }}

{{- define "common.sidecar.init.container" -}}
  {{- if .Values.global.installSidecarSecurity }}
- name: {{ .Values.global.tproxyConfig.name }}
  image: "{{ include "common.repository" . }}/{{ .Values.global.tproxyConfig.image }}"
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  securityContext:
    privileged: true
  {{- end }}
{{- end }}

{{- define "common.sidecar.container" -}}
  {{- if .Values.global.installSidecarSecurity }}
- name: {{ .Values.global.rproxy.name }}
  image: "{{ include "common.repository" . }}/{{ .Values.global.rproxy.image }}"
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  env:
  - name: CONFIG_HOME
    value: "/opt/app/rproxy/config"
  - name: KEY_STORE_PASSWORD
    value: {{ .Values.config.keyStorePassword }}
  - name: spring_profiles_active
    value: {{ .Values.global.rproxy.activeSpringProfiles }}
  volumeMounts:
  - name: {{ include "common.fullname" . }}-rproxy-config
    mountPath: /opt/app/rproxy/config/forward-proxy.properties
    subPath: forward-proxy.properties
  - name: {{ include "common.fullname" . }}-rproxy-config
    mountPath: /opt/app/rproxy/config/primary-service.properties
    subPath: primary-service.properties
  - name: {{ include "common.fullname" . }}-rproxy-config
    mountPath: /opt/app/rproxy/config/reverse-proxy.properties
    subPath: reverse-proxy.properties
  - name: {{ include "common.fullname" . }}-rproxy-config
    mountPath: /opt/app/rproxy/config/cadi.properties
    subPath: cadi.properties
  - name: {{ include "common.fullname" . }}-rproxy-log-config
    mountPath: /opt/app/rproxy/config/logback-spring.xml
    subPath: logback-spring.xml
  - name: {{ include "common.fullname" . }}-rproxy-uri-auth-config
    mountPath: /opt/app/rproxy/config/auth/uri-authorization.json
    subPath: uri-authorization.json
  - name: {{ include "common.fullname" . }}-rproxy-auth-config
    mountPath: /opt/app/rproxy/config/auth/tomcat_keystore
    subPath: tomcat_keystore
  - name: {{ include "common.fullname" . }}-rproxy-auth-config
    mountPath: /opt/app/rproxy/config/auth/client-cert.p12
    subPath: client-cert.p12
  - name: {{ include "common.fullname" . }}-rproxy-auth-config
    mountPath: /opt/app/rproxy/config/auth/aaf_truststore.jks
    subPath: aaf_truststore.jks
  - name: {{ include "common.fullname" . }}-rproxy-security-config
    mountPath: /opt/app/rproxy/config/security/keyfile
    subPath: keyfile
  ports:
  - containerPort: {{ .Values.global.rproxy.port }}
- name: {{ .Values.global.fproxy.name }}
  image: "{{ include "common.repository" . }}/{{ .Values.global.fproxy.image }}"
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  env:
  - name: CONFIG_HOME
    value: "/opt/app/fproxy/config"
  - name: KEY_STORE_PASSWORD
    value: {{ .Values.config.keyStorePassword }}
  - name: spring_profiles_active
    value: {{ .Values.global.fproxy.activeSpringProfiles }}
  volumeMounts:
  - name: {{ include "common.fullname" . }}-fproxy-config
    mountPath: /opt/app/fproxy/config/fproxy.properties
    subPath: fproxy.properties
  - name: {{ include "common.fullname" . }}-fproxy-log-config
    mountPath: /opt/app/fproxy/config/logback-spring.xml
    subPath: logback-spring.xml
  - name: {{ include "common.fullname" . }}-fproxy-auth-config
    mountPath: /opt/app/fproxy/config/auth/tomcat_keystore
    subPath: tomcat_keystore
  - name: {{ include "common.fullname" . }}-fproxy-auth-config
    mountPath: /opt/app/fproxy/config/auth/client-cert.p12
    subPath: client-cert.p12
  ports:
  - containerPort: {{ .Values.global.fproxy.port }}
  {{- end }}
{{- end }}


{{- define "common.sidecar.volumes" -}}
  {{- if .Values.global.installSidecarSecurity }}
- name: {{ include "common.fullname" . }}-rproxy-config
  configMap:
    name: {{ include "common.fullname" . }}-rproxy-config
- name: {{ include "common.fullname" . }}-rproxy-log-config
  configMap:
    name: {{ include "common.fullname" . }}-rproxy-log-config
- name: {{ include "common.fullname" . }}-rproxy-uri-auth-config
  configMap:
    name: {{ include "common.fullname" . }}-rproxy-uri-auth-config
- name: {{ include "common.fullname" . }}-rproxy-auth-config
  secret:
    secretName: {{ include "common.fullname" . }}-rproxy-auth-config
- name: {{ include "common.fullname" . }}-rproxy-security-config
  secret:
    secretName: {{ include "common.fullname" . }}-rproxy-security-config
- name: {{ include "common.fullname" . }}-fproxy-config
  configMap:
    name: {{ include "common.fullname" . }}-fproxy-config
- name: {{ include "common.fullname" . }}-fproxy-log-config
  configMap:
    name: {{ include "common.fullname" . }}-fproxy-log-config
- name: {{ include "common.fullname" . }}-fproxy-auth-config
  secret:
    secretName: {{ include "common.fullname" . }}-fproxy-auth-config
  {{- end }}
{{- end }}

{{- define "common.sidecar.configmaps" -}}
{{ if .Values.global.installSidecarSecurity }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-fproxy-config
  namespace: {{ include "common.namespace" . }}
data:
{{ tpl (.Files.Glob "resources/fproxy/config/*").AsConfig . | indent 2 }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-fproxy-log-config
  namespace: {{ include "common.namespace" . }}
data:
{{ tpl (.Files.Glob "resources/fproxy/config/logback-spring.xml").AsConfig . | indent 2 }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-rproxy-config
  namespace: {{ include "common.namespace" . }}
data:
{{ tpl (.Files.Glob "resources/rproxy/config/*").AsConfig . | indent 2 }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-rproxy-log-config
  namespace: {{ include "common.namespace" . }}
data:
{{ tpl (.Files.Glob "resources/rproxy/config/logback-spring.xml").AsConfig . | indent 2 }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-rproxy-uri-auth-config
  namespace: {{ include "common.namespace" . }}
data:
{{ tpl (.Files.Glob "resources/rproxy/config/auth/uri-authorization.json").AsConfig . | indent 2 }}
{{ end }}
{{- end }}

{{- define "common.sidecar.secrets" -}}
  {{- if .Values.global.installSidecarSecurity }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.fullname" . }}-fproxy-auth-config
  namespace: {{ include "common.namespace" . }}
  labels:
    app: {{ include "common.name" . }}
    chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
type: Opaque
data:
{{ tpl (.Files.Glob "resources/fproxy/config/auth/*").AsSecrets . | indent 2 }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.fullname" . }}-rproxy-auth-config
  namespace: {{ include "common.namespace" . }}
  labels:
    app: {{ include "common.name" . }}
    chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
type: Opaque
data:
{{ tpl (.Files.Glob "resources/rproxy/config/auth/*").AsSecrets . | indent 2 }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.fullname" . }}-rproxy-security-config
  namespace: {{ include "common.namespace" . }}
  labels:
    app: {{ include "common.name" . }}
    chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
type: Opaque
data:
{{ tpl (.Files.Glob "resources/rproxy/config/security/*").AsSecrets . | indent 2 }}
  {{- end }}
{{- end }}
