; Keywords; Comments
(comment) @comment

; Keywords - Definition types
(keyword_def) @keyword

; Keywords - Reference
(keyword_ref) @keyword

; Keywords - Enum
(keyword_enum) @keyword

; Keywords - Special keywords
[
  "as"
  "default"
  "name"
  "database_type"
] @keyword

; Index keyword
(indexes) @keyword

; Note keyword
(note_start) @keyword

; Default keyword
(default_start) @keyword

; Name keyword
(name_start) @keyword

; Setting kinds (constraints and properties)
(setting_kind) @property

; Types
(type) @type

; Table names (identifier in table context)
(table (identifier) @type)

; Column names
(column (identifier) @variable.member)

; Enum names
(enum (identifier) @type)

; Enum items
(enum_item (identifier) @constant)

; Item names (table columns)
(item (identifier) @variable.member)

; Schema names
(schema (identifier) @namespace)

; Aliases
(_alias (identifier) @variable)

; General identifiers
(identifier) @variable

; Strings - all forms
(string) @string

; Expressions (backtick-quoted SQL/code)
(expression) @string.special

; Numbers
(number) @number

; Booleans
(value
  [
    "true" "TRUE"
    "false" "FALSE"
  ] @constant.builtin.boolean)

; Null
(value ["null" "NULL"] @constant.builtin)

; Operators - relationship cardinality
"<" @operator
">" @operator
"-" @operator
"<>" @operator

; Punctuation - delimiters
[
  ","
  "."
  ":"
] @punctuation.delimiter

; Punctuation - brackets
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket
