{{/*
Expand the name of the chart.
*/}}
{{- define "cf-monitoring.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "cf-monitoring.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cf-monitoring.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cf-monitoring.labels" -}}
helm.sh/chart: {{ include "cf-monitoring.chart" . }}
{{ include "cf-monitoring.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cf-monitoring.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cf-monitoring.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use for Prometheus
*/}}
{{- define "cf-monitoring.prometheus.serviceAccountName" -}}
{{- if .Values.prometheus.serviceAccount.create }}
{{- default (printf "%s-prometheus" (include "cf-monitoring.fullname" .)) .Values.prometheus.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.prometheus.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for Grafana
*/}}
{{- define "cf-monitoring.grafana.serviceAccountName" -}}
{{- if .Values.grafana.serviceAccount.create }}
{{- default (printf "%s-grafana" (include "cf-monitoring.fullname" .)) .Values.grafana.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.grafana.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for Node Exporter
*/}}
{{- define "cf-monitoring.nodeExporter.serviceAccountName" -}}
{{- if .Values.nodeExporter.serviceAccount.create }}
{{- default (printf "%s-node-exporter" (include "cf-monitoring.fullname" .)) .Values.nodeExporter.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.nodeExporter.serviceAccount.name }}
{{- end }}
{{- end }}