return {
  "Olical/conjure",
  ft = { "clojure" },
  config = function()
    -- Let LSP do documentation and jump definitions
    -- For SEXP (Turn off jumping in insert mode)
    vim.cmd([[
    let g:conjure#mapping#doc_word = v:false
    let g:conjure#mapping#def_word= v:false
    let g:sexp_enable_insert_mode_mappings = 0
  ]])

    vim.keymap.set("n", "<localleader>T", ":ConjureEvalRootForm<CR> <bar> :ConjureCljRunCurrentTest<CR>")
    vim.keymap.set("n", "<localleader>tfr", ":ConjureEvalBuf<CR> <bar> :ConjureCljRunCurrentTest<CR>")
  end
}

-- As an example, we can change the default prefix from `<localleader>` to `,c`
-- with the following command:
--
--     :let g:conjure#mapping#prefix = ",c"
--
-- All mappings are prefixed by this by default. To have a mapping work without
-- the prefix simply wrap the string in a list.
--
--     :let g:conjure#mapping#log_split = ["ClS"]
--
-- Now you can hit `ClS` without a prefix in any buffer Conjure has a client for.
--
-- You can disable a mapping entirely by setting it to `v:false` like so.
--
--     :let g:conjure#mapping#doc_word = v:false
--
-- These need to be set before you enter a relevant buffer since the mappings are
-- defined as you enter a buffer and can't be altered after the fact.
--
-- Tip: Booleans in Vim Script are written as `v:true` and `v:false`.
