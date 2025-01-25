; SQL Tagged Template https://www.npmjs.com/package/postgres 
; Treesitter doesn't currently support SQL so we're using QL Syntax instead

; There is an open MR to add SQL support here https://github.com/nvim-treesitter/nvim-treesitter/pull/2511
(call_expression
 function: ((identifier) @_name
   (#eq? @_name "sql"))
 arguments: ((template_string) @ql))
