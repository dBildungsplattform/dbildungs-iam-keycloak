{{/* Define default values for your chart's name. */}}
{{- define "dbildungs-iam.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Define full name for resources. Include the release name as a prefix. */}}
{{- define "dbildungs-iam.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Selector labels for matching labels */}}
{{- define "dbildungs-iam.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dbildungs-iam.name" . }}
layer: dbildungs-iam-keycloak
{{- end -}}

{{/* Secret name */}}
{{- define "dbildungs-iam.secretName" -}}
{{ default (printf "%s-realm-config" (include "dbildungs-iam.fullname" .)) .Values.secret.nameOverride }}
{{- end -}}

{{/* Service name */}}
{{- define "dbildungs-iam.serviceName" -}}
{{ default (printf "%s-keycloak" (include "dbildungs-iam.fullname" .)) .Values.service.nameOverride }}
{{- end -}}

{{/* Ingress host */}}
{{- define "dbildungs-iam.ingressHost" -}}
{{ default "keycloak.dev.spsh.dbildungsplattform.de" .Values.keycloakHostname }}
{{- end -}}
