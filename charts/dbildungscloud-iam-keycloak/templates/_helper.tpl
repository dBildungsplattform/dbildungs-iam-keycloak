{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Create  release name
*/}}
{{- define "common.names.releasename" -}}
{{- .Release.Name -}}
{{- end -}}

{{/*
Service name
*/}}
{{- define "common.names.service" -}}
{{- printf "%s-service" (include "common.names.releasename" .) -}}
{{- end -}}

{{/*
Ingress name
*/}}
{{- define "common.names.ingress" -}}
{{- printf "%s-ingress" (include "common.names.releasename" .) -}}
{{- end -}}

{{/*
Configmap name
*/}}
{{- define "common.names.configmap" -}}
{{- printf "%s-configmap" (include "common.names.releasename" .) -}}
{{- end -}}

{{/*
Deployment name
*/}}
{{- define "common.names.deployment" -}}
{{- printf "%s-deployment" (include "common.names.releasename" .) -}}
{{- end -}}

{{/*
Secret name
*/}}
{{- define "common.names.secret" -}}
{{- printf "%s-secret" (include "common.names.releasename" .) -}}
{{- end -}}





