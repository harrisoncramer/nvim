-- Let LSP do documentation and jump definitions
vim.cmd[[
  let g:conjure#mapping#doc_word = v:false
  let g:conjure#mapping#def_word= v:false
]]

-- Evaluate buffer again and run the current test.
nnoremap('<localleader>T', ':ConjureEvalRootForm<CR> <bar> :ConjureCljRunCurrentTest<CR>')

-- , e b evaluates the current buffer
-- , e f evaluate the code in the file (from the file system)
-- , e e evaluate the current expression
-- , e r evaluate top level form (root)
-- , e ! evaluate current form and replace with result
