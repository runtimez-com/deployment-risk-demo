{{/* Workload name: nameOverride if set, else the chart name. */}}
{{- define "demo-app.name" -}}
{{- default .Chart.Name .Values.nameOverride -}}
{{- end -}}
