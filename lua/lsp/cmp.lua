local cmp_status_ok, cmp = pcall(require, "cmp")

if not cmp_status_ok then
  vim.api.nvim_err_writeln("cmp not yet installed!")
  return
end

local cmp_sources = {
  { name = "path",                   max_item_count = 10 },
  { name = "nvim_lsp",               max_item_count = 5 },
  { name = "nvim_lua",               max_item_count = 5 },
  { name = "ultisnips",              max_item_count = 5 },
  { name = "buffer",                 max_item_count = 5 },
  { name = "nvim_lsp_signature_help" },
}

-- Setup completion engine
if cmp_status_ok then
  cmp.setup({
    preselect = cmp.PreselectMode.None, -- Don't automatically chose from a list
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = {
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
      ["<S-Down>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ["<S-Up>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    },
    sources = cmp.config.sources(cmp_sources),
  })
end
