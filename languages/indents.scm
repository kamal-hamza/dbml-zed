; Increase indent after opening braces
("{" @indent)

; Decrease indent before closing braces
("}" @outdent)

; Increase indent after opening brackets
("[" @indent)

; Decrease indent before closing brackets
("]" @outdent)

; Increase indent after opening parentheses
("(" @indent)

; Decrease indent before closing parentheses
(")" @outdent)

; Increase indent for table definitions
(table_definition) @indent

; Increase indent for enum definitions
(enum_definition) @indent

; Increase indent for project definitions
(project_definition) @indent

; Increase indent for tablegroup definitions
(tablegroup_definition) @indent

; Increase indent for indexes blocks
(indexes_definition) @indent

; Increase indent for note blocks
(note_block) @indent

; Keep same indentation for table/enum/project contents
(table_body) @indent
(enum_body) @indent
(project_body) @indent

; Handle column definitions
(column_definition) @indent.always

; Handle multi-line settings
(column_settings) @indent.always
(index_settings) @indent.always
(reference_settings) @indent.always
