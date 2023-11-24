{{/*
Define default values for your chart's name.
*/}}
{{- define "dbildungscloud-iam-keycloak.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define full name for resources. Include the release name as a prefix.
*/}}
{{- define "dbildungscloud-iam-keycloak.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "dbildungscloud-iam-keycloak.name" .) | trunc 63 | trimSuffix "-" -}}
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
