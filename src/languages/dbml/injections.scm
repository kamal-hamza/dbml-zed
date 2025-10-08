; SQL injection in default values with backticks
((default_value) @injection.content
 (#match? @injection.content "^`.*`$")
 (#set! injection.language "sql"))

; JSON injection in json/jsonb columns or attributes
((column_type) @injection.content
 (#match? @injection.content "^json")
 (#set! injection.language "json"))
