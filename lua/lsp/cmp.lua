local cmp_status_ok, cmp = pcall(require, "cmp")
local lspkind_status_ok, lspkind = pcall(require, "lspkind")

if not (cmp_status_ok and lspkind_status_ok) then
  print("CMP dependencies not yet installed!")
  return
end

-- Setup completion engine
if cmp_status_ok then
  cmp.setup({
    preselect = cmp.PreselectMode.None, -- Don't automatically chose from a list
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    formatting = {
      format = lspkind.cmp_format({
        with_text = false, -- do not show text alongside icons
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      }),
    },
    mapping = {
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp", max_item_count = 5 },
      { name = "nvim_lua", max_item_count = 5 },
      { name = "ultisnips", max_item_count = 5 },
      { name = "buffer", max_item_count = 5 },
      { name = "nvim_lsp_signature_help" },
    }),
  })
end
