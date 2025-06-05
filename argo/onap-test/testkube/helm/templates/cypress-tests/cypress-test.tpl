{{/* https://docs.testkube.io/articles/crds/tests.testkube.io-v3 */}}
{{/*
Common test template for cypress tests

@param .dot   (Optional, default .) The root scope
@param .repo  A map representing the repository configuration
              The map must contain at least the following fields:
                .repo.uri:    the uri of the git repo that
                              contains the cypress project
                .repo.branch  the branch of the git repo that
                              contains the cypress project
@param .test  A map representing a single test
              The map must contain at least the following fields:
                .test.name: The name of the test
              The map may contain the following optional fields:
                .test.env: environment variables for the container

Example include:
    {{ include "cypress.test" (dict "repo" .Values.tests.cypress "test" .Values.tests.cypress.tests.aai) }}
*/}}
{{- define "cypress.test" }}
apiVersion: tests.testkube.io/v3
kind: Test
metadata:
  name: {{ kebabcase .test.testName }}
spec:
  type: cypress/project
  content:
    type: git
    repository:
      type: git
      uri: {{ .repo.uri }}
      branch: {{ .test.branch | default .repo.branch }}
      tokenSecret:
        key: git-token
        name: testkube-git-creds
      usernameSecret:
        key: git-username
        name: testkube-git-creds
  executionRequest:
    activeDeadlineSeconds: 1800
    jobTemplate: |
      apiVersion: batch/v1
      kind: Job
      metadata:
        annotations:
          argocd.argoproj.io/compare-options: IgnoreExtraneous
          argocd.argoproj.io/sync-options: Prune=false
      spec:
        template:
          metadata:
            labels:
              sidecar.istio.io/inject: 'false'
          spec:
            containers:
            - name: {{ kebabcase .test.testName }}
              image: {{ .repo.image }}
              imagePullPolicy: IfNotPresent
              resources:
                requests:
                  cpu: 300m
                  memory: 300Mi
    {{- if .test.env }}
    envs:
    {{- range $key, $value := .test.env }}
      {{ $key }}: {{ $value | quote }}
    {{ end -}}
    {{ end -}}
{{ end -}}
