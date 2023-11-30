{{/*
Define default values for your chart's name.
*/}}
{{- define "dbildungscloud-iam-keycloak.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Define full name for resources using only the chart name.
*/}}
{{- define "dbildungscloud-iam-keycloak.fullname" -}}
{{- if .Values.nameOverride -}}
{{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- include "dbildungscloud-iam-keycloak.name" . | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{/*
Selector labels for matching labels
*/}}
{{- define "dbildungscloud-iam-keycloak.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dbildungscloud-iam-keycloak.name" . }}
{{- end -}}
{{/*
Secret name
*/}}
{{- define "dbildungscloud-iam-keycloak.secretName" -}}
{{- printf "%s-realm-config" (include "dbildungscloud-iam-keycloak.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Service name
*/}}
{{- define "dbildungscloud-iam-keycloak.serviceName" -}}
{{- printf "%s-service" (include "dbildungscloud-iam-keycloak.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Ingress host
*/}}
{{- define "dbildungscloud-iam-keycloak.ingressHost" -}}
{{ default (printf "%s.dev.spsh.dbildungsplattform.de" (include "dbildungscloud-iam-keycloak.fullname" .)) .Values.keycloakHostname }}
{{- end -}}
