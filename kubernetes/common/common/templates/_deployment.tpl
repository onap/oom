{{- define "common.deployment" -}}
{{- $global := . }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.fullname" . }}
  namespace: {{ include "common.namespace" . }}
  labels:
    app: {{ include "common.name" . }}
    chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  replicas: {{ .Values.replicaCount }}
{{- if .Values.affinity }}
  affinity:
{{ toYaml .Values.affinity | indent 4 }}
{{- end }}
  selector:
    matchLabels:
      app: {{ include "common.name" . }}
  template:
    metadata:
      labels:
        app: {{ include "common.name" . }}
        release: {{ .Release.Name }}
      name: {{ include "common.name" . }}
      annotations:
        {{- if .Values.configMaps }}
        checksum/config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
        {{- end }}
        {{- if .Values.secrets }}
        {{- $secretFileName := .Values.secretFileName | default "secret.yaml" }}
        checksum/secret: {{ include (print $.Template.BasePath "/" $secretFileName) . | sha256sum }}
        {{- end }}
        {{- if .Values.annotations }}
        {{- with .Values.annotations }}
        annotations:
        {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- end }}
    spec:
      {{- include "common.sidecar.init.container" . }}
      {{- if .Values.securityContext }}
        {{- if .Values.securityContext.enabled }}
      securityContext:
        runAsUser: {{ .Values.config.userId }}
        fsGroup: {{ .Values.config.groupId }}
        {{- end }}
      {{- end }}
      {{- if .Values.initContainers }}
      {{- if .Values.initContainers.enabled }}
      initContainers:
      {{- include "common.sidecar.init.container" . | nindent 6 }}
        {{- if .Values.initContainers.jobWaitList }}
      - command:
        - /root/job_complete.py
        args:
          {{- range $job := .Values.initContainers.jobWaitList }}
        - --job-name
        - {{ tpl $job $global }}
          {{- end }}
        env:
        - name: NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        image: "{{ .Values.global.readinessRepository }}/{{ .Values.global.readinessImage }}"
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
        name: {{ include "common.name" . }}-jobs-readiness
        {{- end }}
        {{- if .Values.initContainers.containerWaitList }}
      - command:
        - /root/ready.py
        args:
          {{- range $container := .Values.initContainers.containerWaitList }}
        - --container-name
        - {{ tpl $container $global }}
          {{- end }}
        env:
        - name: NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        image: "{{ .Values.global.readinessRepository }}/{{ .Values.global.readinessImage }}"
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
        name: {{ include "common.name" . }}-containers-readiness
        {{- end }}
      {{- if .Values.initContainers.changeLogsPermission }}
      - command:
        - sh
        - -c
        - |
          set -x;
          {{- $global := . }}
          {{- range $volumeMount := .Values.volumeMounts }}
          if [ -d "{{ $volumeMount.mountPath }}" ]; then
            chmod 777 {{ $volumeMount.mountPath }}; chown -R ${LOCAL_USER_ID}:${LOCAL_GROUP_ID} /{{ $volumeMount.mountPath }};
          else
            mkdir -p {{ $volumeMount.mountPath }}
            chmod 777 {{ $volumeMount.mountPath }}; chown -R ${LOCAL_USER_ID}:${LOCAL_GROUP_ID} {{ $volumeMount.mountPath }};
          fi
          chown -R ${LOCAL_USER_ID}:${LOCAL_GROUP_ID} /opt/app/;
          chmod -R g+s /opt/app/;
          {{- end }}
        env:
        - name: NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: LOCAL_USER_ID
          value: {{ .Values.config.userId | quote }}
        - name: LOCAL_GROUP_ID
          value: {{ .Values.config.groupId | quote }}
        image: "{{ include "common.repository" . }}/{{ .Values.global.alpineImage }}"
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
        name: {{ include "common.name" . }}-change-logs-ownership
        {{- if .Values.securityContext }}
        {{- if .Values.securityContext.enabled }}
        securityContext:
          allowPrivilegeEscalation: true
        {{- end }}
        {{- end }}
        volumeMounts:
          {{- range $volumeMount := .Values.volumeMounts }}
          - name: {{ $volumeMount.name }}
            mountPath: {{ $volumeMount.mountPath }}
            {{- if $volumeMount.subPath }}
            subPath: {{ $volumeMount.subPath }}
            {{- end }}
          {{- end }}
      {{- end }}
      {{- end }}
      {{- end }}
      containers:
      - name: {{ include "common.name" . }}
        image: '{{ include "common.repository" . }}/{{ .Values.image }}'
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
        {{- if .Values.debugContainer }}
        command: ["/bin/sleep", "5000"]
        {{- end }}
        {{- if .Values.securityContext }}
          {{- if .Values.securityContext.enabled }}
        securityContext:
          allowPrivilegeEscalation: false
          {{- end }}
        {{- end }}
        env:
        {{- if .Values.config }}
        {{- if .Values.config.userId }}
        - name: LOCAL_USER_ID
          value: {{ .Values.config.userId | quote }}
        {{- end }}
        {{- if .Values.config.groupId }}
        - name: LOCAL_GROUP_ID
          value: {{ .Values.config.groupId | quote }}
        {{- end }}
        {{- end }}
        {{- range $env := .Values.envs }}
        - name: {{ $env.name }}
          {{- if $env.valueFrom }}
          valueFrom:
            {{- if $env.valueFrom.secretKeyRef }}
            secretKeyRef:
              name: {{ tpl $env.valueFrom.secretKeyRef.name $global }}
              key: {{ $env.valueFrom.secretKeyRef.key }}
            {{- else if $env.valueFrom.configMapKeyRef }}
            configMapKeyRef:
              name: {{ tpl $env.valueFrom.configMapKeyRef.name $global }}
              key: {{ $env.valueFrom.configMapKeyRef.key }}
            {{- end }}
          {{- else }}
          value: {{ tpl $env.value $global | quote }}
          {{- end }}
        {{- end }}
        volumeMounts:
        - mountPath: /etc/localtime
          name: localtime
          readOnly: true
          {{- $global := . }}
          {{- range $volumeMount := .Values.volumeMounts }}
        - name: {{ tpl $volumeMount.name $global }}
          mountPath: {{ tpl $volumeMount.mountPath $global }}
          {{- if $volumeMount.subPath }}
          subPath: {{ $volumeMount.subPath }}
          {{- end }}
          {{- end }}
        ports:
        - containerPort: {{ .Values.service.internalPort }}
        {{- if .Values.service.internalPort2 }}
        - containerPort: {{ .Values.service.internalPort2 }}
        {{- end }}
        # disable liveness probe when breakpoints set in debugger
        # so K8s doesn't restart unresponsive container
        {{ if .Values.liveness.enabled }}
        livenessProbe:
          tcpSocket:
            port: {{ .Values.service.internalPort }}
          initialDelaySeconds: {{ .Values.liveness.initialDelaySeconds }}
          periodSeconds: {{ .Values.liveness.periodSeconds }}
        {{ end }}
        readinessProbe:
          tcpSocket:
            port: {{ .Values.service.internalPort }}
          initialDelaySeconds: {{ .Values.readiness.initialDelaySeconds }}
          periodSeconds: {{ .Values.readiness.periodSeconds }}
        resources:
{{ include "common.resources" . }}
      {{- if .Values.nodeSelector }}
      nodeSelector:
{{ toYaml .Values.nodeSelector | indent 8 }}
      {{- end }}

      {{- $values := .Values }}
      {{- if .Values.sideCarContainers }}
        {{- if .Values.sideCarContainers.filebeat }}
        {{- if .Values.sideCarContainers.filebeat.enabled }}
      - name: filebeat-onap
        image: '{{ .Values.global.loggingRepository }}/{{ .Values.global.loggingImage }}'
        imagePullPolicy: '{{ .Values.global.pullPolicy | default .Values.pullPolicy }}'
        volumeMounts:
          - mountPath: /usr/share/filebeat/filebeat.yml
            name: filebeat-conf
            subPath: filebeat.yml
          - mountPath: /var/log/onap
            name: '{{ include "common.fullname" . }}-logs'
          - mountPath: /usr/share/filebeat/data
            name: 'filebeat-data'
        {{- end }}
        {{- end }}
        {{- if .Values.sideCarContainers.containers }}
        {{- range $sideCarContainer := .Values.sideCarContainers.containers }}
      - name: {{ tpl $sideCarContainer.name $global }}
        image: {{ tpl $sideCarContainer.image $global }}
        imagePullPolicy: {{ $values.global.pullPolicy | default $values.pullPolicy }}
        {{- if $sideCarContainer.volumeMounts }}
        volumeMounts:
          {{- range $volumeMount := $sideCarContainer.volumeMounts }}
        - name: {{ tpl $volumeMount.name $global }}
          mountPath: {{ tpl $volumeMount.mountPath $global }}
            {{- if $volumeMount.subPath }}
          subPath: {{ tpl $volumeMount.subPath $global }}
            {{- end }}
          {{- end }}
        {{- end }}
        {{- end }}
        {{- end }}
      {{- end }}
      {{- include "common.sidecar.container" . | nindent 6 }}
      volumes:
      - name: localtime
        hostPath:
          path: /etc/localtime
      {{- $global := . }}
      {{- range $volume := .Values.volumes }}
      - name: {{ tpl $volume.volumeMountRefName $global }}
        {{- if eq $volume.type "emptyDir" }}
        emptyDir: {}
        {{- else if eq $volume.type "configMap" }}
        configMap:
          name: {{ tpl $volume.name $global }}
          {{- if $volume.items  }}
          items:
            {{- range $item := $volume.items }}
            - key: {{ $item.key }}
              path: {{ $item.path }}
            {{- end }}
          {{- end }}
        {{- else if eq $volume.type "secret" }}
        secret:
          secretName: {{ tpl $volume.name $global }}
          {{- if $volume.items  }}
          items:
            {{- range $item := $volume.items }}
            - key: {{ $item.key }}
              path: {{ $item.path }}
            {{- end }}
          {{- end }}
        {{- else if eq $volume.type "hostPath" }}
        hostPath:
          path: {{ tpl $volume.path $global }}
        {{- else if eq $volume.type "persistentVolumeClaim" }}
          {{- if $global.Values.persistence.enabled }}
        persistentVolumeClaim:
          claimName: {{ tpl $volume.name $global }}
          {{- else }}
        emptyDir: {}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- include "common.sidecar.volumes" . | nindent 6 }}
      restartPolicy: {{ .Values.restartPolicy }}
      imagePullSecrets:
      - name: '{{ include "common.namespace" . }}-docker-registry-key'
{{- end -}}
