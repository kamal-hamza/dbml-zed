; Breadcrumbs for DBML files

; Table declarations
(table_definition
  name: (identifier) @name) @type
(#set! "type" "class")

; Enum declarations
(enum_definition
  name: (identifier) @name) @type
(#set! "type" "enum")

; Column declarations within tables
(column_definition
  name: (identifier) @name) @type
(#set! "type" "property")

; Index blocks within tables
(indexes_definition) @type
(#set! "type" "namespace")

; Reference declarations
(ref_definition
  name: (identifier)? @name) @type
(#set! "type" "interface")

; Project declarations
(project_definition
  name: (identifier)? @name) @type
(#set! "type" "module")
