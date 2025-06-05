{{- define "sidecarKiller" }}
{{/*
{{ include "sidecarKiller" (dict "containerName" "containerNameToCheck" "Values" .Values) }}
*/}}
- name: sidecar-killer
  image: {{ .Values.serviceMesh.sidecarKiller.image }}
  command: ["/bin/sh", "-c"]
  args: ["echo \"waiting 10s for istio side cars to be up\"; sleep 10s; /app/ready.py --service-mesh-check {{ .containerName }} -t 45;"]
  env:
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
{{ end -}}

{{- define "smoke.test" }}
{{/* Define smoke test template */}}
{{- $dot := default . .dot -}}
{{- $configurationName := default .onapTestName .configurationName }}
{{- $executor := default $dot.Values.tests.smokeTests.executor.pythonsdk.type .executor }}
{{- $testEnv := default $dot.Values.tests.testEnvName .testEnvName }}
{{- $schedule := default "" .schedule }}
{{/* - if hasKey $dot.Values.tests.configuration $executor */}}
{{- $executorRepoConfig := get $dot.Values.tests.configuration $executor }}
{{- $uri := default "" $executorRepoConfig.uri }}
{{- $branch := default "master" $executorRepoConfig.branch }}
{{- $path := default "/" $executorRepoConfig.path }}
{{/* - else */}}
{{/* - fail "Executor has to have git configuration set in .Values.tests.configuration" -*/}}
{{/*- end */}}
apiVersion: tests.testkube.io/v3
kind: Test
metadata:
  name: {{ .testName }}
spec:
  type: {{ $executor }}
  executionRequest:
    args:
    - $(TESTNAME)
    envs:
      NAMESPACE: "{{ $dot.Values.namespace }}"
      TESTNAME: {{ .onapTestName }}
      PYTHONPATH: $PYTHONPATH:/data/repo{{ $path }}/basic_configuration_settings
      ONAP_PYTHON_SDK_SETTINGS: "{{ $configurationName }}.{{ $configurationName }}_configuration"
      TEST_ENV_NAME: "{{ $testEnv }}"
      {{- if $dot.Values.tests.slackNotifications.enabled }}
      SLACK_TOKEN: "{{ $dot.Values.tests.slackNotifications.slackConfig.token }}"
      SLACK_URL: {{ $dot.Values.tests.slackNotifications.slackConfig.baseUrl }}
      SLACK_CHANNEL: "{{ $dot.Values.tests.slackNotifications.slackConfig.channel }}"
      {{- end }}
      {{- if $dot.Values.global.serviceMesh.enabled }}
      {{- range $key, $val := $dot.Values.serviceMesh.envVariable }}
      {{ $key }}: {{ $val | quote }}
      {{- end }}
      {{- end }}
    artifactRequest:
      storageClassName: {{ $dot.Values.tests.smokeTests.artifacts.storageClassName }}
      volumeMountPath: /tmp
    activeDeadlineSeconds: {{ $dot.Values.tests.smokeTests.execution.activeDeadlineSeconds }}
    {{- include "job.template" $dot | indent 4 }}
    {{- if $dot.Values.global.serviceMesh.enabled }}
    {{- include "scraper.template" $dot | indent 4 }}
    {{- end }}
  content:
    type: git-file
    repository:
      type: git
      uri: {{ $uri }}
      branch: {{ $branch }}
      path: {{ $path }}
      tokenSecret:
        key: git-token
        name: {{ $executorRepoConfig.secretName | default "tnap-testkube-git-creds" }}
      usernameSecret:
        key: git-username
        name: {{ $executorRepoConfig.secretName | default "tnap-testkube-git-creds" }}
  {{- if $schedule }}
  schedule: "{{ $schedule }}"
  {{- end }}
{{ end -}}
