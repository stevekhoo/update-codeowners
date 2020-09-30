{{- define "escape_chars" }}{{ . | strings.ReplaceAll "_" "\\_" | strings.ReplaceAll "|" "\\|" | strings.ReplaceAll "*" "\\*" }}{{- end }}
{{- define "escape_spaces" }}{{ . | strings.ReplaceAll " " "_" }}{{- end }}
{{- define "sanatize_string" }}{{ . | strings.ReplaceAll "\n\n" "<br><br>" | strings.ReplaceAll "  \n" "<br>" | strings.ReplaceAll "\n" "<br>" | tmpl.Exec "escape_chars" }}{{- end }}
{{- define "sanitize_url" }}{{ . | strings.ReplaceAll "_" "__" | strings.ReplaceAll "\n" " " | strings.ReplaceAll "<br>" " " | strings.ReplaceAll "  " " " | strings.ReplaceAll "-" "--" | tmpl.Exec "escape_spaces" }}{{- end }}
{{- define "sanitize_boolean" }}{{ . | strings.ReplaceAll "true" "yes" | strings.ReplaceAll "false" "no" | tmpl.Exec "sanitize_url" }}{{- end }}
{{- define "boolean_color" }}{{ . | strings.ReplaceAll "true" "important" | strings.ReplaceAll "false" "inactive" | tmpl.Exec "sanitize_url" }}{{- end }}
{{- $action := (datasource "action") -}}
## Inputs
{{- range $key, $input := $action.inputs }}

### {{ tmpl.Exec "escape_chars" $key }}
![Required](https://img.shields.io/badge/Required-{{ if ((has $input "required") and ($input.required ne "")) }}{{ tmpl.Exec "sanitize_boolean" $input.required }}{{ else }}no{{ end }}-{{ if ((has $input "required") and ($input.required ne "")) }}{{ tmpl.Exec "boolean_color" $input.required }}{{ else }}inactive{{ end }}?style=flat-square)
![Default](https://img.shields.io/badge/Default-{{ if (has $input "default") }}{{ if ($input.default ne "") }}{{ tmpl.Exec "sanitize_url" $input.default }}{{ else }}''{{ end }}{{ else }}none{{ end }}-{{ if ((has $input "default") and ($input.default ne "")) }}{{ strings.Trunc 6 (crypto.SHA1 $input.default) }}{{ else }}inactive{{ end }}?style=flat-square)

{{ tmpl.Exec "escape_chars" $input.description }}
{{- end }}
{{ if (has $action "outputs") }}
## Outputs

{{- range $key, $output := $action.outputs }}

### {{ tmpl.Exec "escape_chars" $key }}

{{ if (has $output "description") }}{{ tmpl.Exec "escape_chars" $output.description }}{{ end }}
{{- end }}
{{- end }}
