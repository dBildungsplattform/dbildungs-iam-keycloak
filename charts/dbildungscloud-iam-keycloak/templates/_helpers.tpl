{{/* Define default values for your chart's name. */}}
{{- define "dbildungscloud-iam-keycloak.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Define full name for resources. Include the release name as a prefix, but avoid duplicating the chart name. */}}
{{- define "dbildungscloud-iam-keycloak.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Selector labels for matching labels */}}
{{- define "dbildungscloud-iam-keycloak.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dbildungscloud-iam-keycloak.name" . }}
layer: dbildungscloud-iam-keycloak
{{- end -}}

{{/* Secret name */}}
{{- define "dbildungscloud-iam-keycloak.secretName" -}}
{{ default (printf "%s-realm-config" (include "dbildungscloud-iam-keycloak.fullname" .)) .Values.secret.nameOverride }}
{{- end -}}

{{/* Service name */}}
{{- define "dbildungscloud-iam-keycloak.serviceName" -}}
{{- $fullName := include "dbildungscloud-iam-keycloak.fullname" . -}}
{{- if hasSuffix "-keycloak" $fullName -}}
{{- $fullName -}}
{{- else -}}
{{- printf "%s-keycloak" $fullName -}}
{{- end -}}
{{- end -}}

{{/* Ingress host */}}
{{- define "dbildungscloud-iam-keycloak.ingressHost" -}}
{{ default "keycloak.dev.spsh.dbildungsplattform.de" .Values.keycloakHostname }}
{{- end -}}
