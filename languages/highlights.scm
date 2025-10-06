; Keywords - Core DBML constructs
[
  "Table"
  "Ref"
  "Enum"
  "Project"
  "TableGroup"
  "indexes"
  "as"
  "Note"
] @keyword

; Relationship operators
[
  ">"
  "<"
  "-"
] @operator

; Common SQL data types
[
  "int"
  "integer"
  "bigint"
  "smallint"
  "tinyint"
  "mediumint"
  "serial"
  "bigserial"
  "varchar"
  "char"
  "character"
  "text"
  "tinytext"
  "mediumtext"
  "longtext"
  "string"
  "boolean"
  "bool"
  "bit"
  "datetime"
  "timestamp"
  "timestamptz"
  "date"
  "time"
  "timetz"
  "year"
  "float"
  "float4"
  "float8"
  "double"
  "real"
  "decimal"
  "numeric"
  "money"
  "json"
  "jsonb"
  "xml"
  "uuid"
  "binary"
  "varbinary"
  "blob"
  "tinyblob"
  "mediumblob"
  "longblob"
  "bytea"
  "array"
  "enum"
  "set"
  "geometry"
  "point"
  "polygon"
  "inet"
  "cidr"
  "macaddr"
] @type

; Column constraints and settings
[
  "pk"
  "primary key"
  "null"
  "not null"
  "unique"
  "increment"
  "autoincrement"
  "auto_increment"
  "default"
  "ref"
  "note"
  "index"
  "indexes"
] @property

; Relationship actions
[
  "cascade"
  "restrict"
  "set null"
  "set default"
  "no action"
  "delete"
  "update"
] @keyword.control

; Identifiers
(identifier) @variable

; Table names
(table_name) @type.definition

; Column names
(column_name) @variable.member

; Enum values
(enum_value) @constant

; Strings - both single and double quoted
(string) @string
(quoted_string) @string

; Numbers - integers and decimals
(number) @number
(integer) @number
(decimal) @number

; Booleans
[
  "true"
  "false"
  "TRUE"
  "FALSE"
] @constant.builtin.boolean

; Comments - single line and block
(comment) @comment
(line_comment) @comment.line
(block_comment) @comment.block

; Punctuation
[
  ","
  "."
  ":"
  ";"
] @punctuation.delimiter

; Brackets
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

; Database name in Project
(project_name) @namespace

; Special properties and note content
(note_content) @string.documentation

; Column settings in square brackets
(column_settings) @attribute

; Index settings
(index_settings) @attribute

; Reference settings
(reference_settings) @attribute

; Escape sequences in strings
(escape_sequence) @string.escape
