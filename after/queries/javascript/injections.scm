; SQL Tagged Template https://www.npmjs.com/package/postgres 
; Treesitter doesn't currently support SQL so we're using QL Syntax instead

(call_expression
 function: ((identifier) @_name
   (#eq? @_name "sql"))
 arguments: ((template_string) @ql))
