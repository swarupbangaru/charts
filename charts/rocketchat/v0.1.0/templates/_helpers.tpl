{{/* vim: set filetype=mustache: */}}
{{/**
 * Expand the name of the chart.
 */}}
{{- define "rocketchat.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
 * Create a default fully qualified app name.
 * We truncate at 63 chars because some Kubernetes name fields are limited to this
 * (by the DNS naming spec).
 */}}
{{- define "rocketchat.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate base_url
*/}}
{{- define "rocketchat.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := (index .Values.ingress.hosts.rocketchat 0) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- printf "http://%s-rocketchat" (include "rocketchat.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}
