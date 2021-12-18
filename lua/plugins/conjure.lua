local M = {}
M.setup = function(remap)
  -- Let LSP do documentation and jump definitions
  vim.cmd [[
    let g:conjure#mapping#doc_word = v:false
    let g:conjure#mapping#def_word= v:false
  ]]

  remap {
      'n', '<localleader>T',
      ':ConjureEvalRootForm<CR> <bar> :ConjureCljRunCurrentTest<CR>'
  }

end
return M
