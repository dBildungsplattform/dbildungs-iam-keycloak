{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Create  release name.
*/}}
{{- define "common.names.releasename" -}}
{{- .Release.Name -}}
{{- end -}}

{{/*
service name.
*/}}
{{- define "common.names.service" -}}
{{- printf "%s-service" (include "common.names.releasename" .) -}}
{{- end -}}

{{/*
ingress
*/}}
{{- define "common.names.ingress" -}}
{{- printf "%s-ingress" (include "common.names.releasename" .) -}}
{{- end -}}

{{/*
configmap
*/}}
{{- define "common.names.configmap" -}}
{{- printf "%s-configmap" (include "common.names.releasename" .) -}}
{{- end -}}

{{/*
Deployment
*/}}
{{- define "common.names.deployment" -}}
{{- printf "%s-deployment" (include "common.names.releasename" .) -}}
{{- end -}}

