local colors = require("colorscheme")
local cmp_status_ok, cmp = pcall(require, "cmp")
local lspkind_status_ok, lspkind = pcall(require, "lspkind")

if not (cmp_status_ok and lspkind_status_ok) then
  vim.api.nvim_err_writeln("CMP dependencies not yet installed!")
  return
end

lspkind.init({
  symbol_map = {
    Copilot = "",
  },
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = colors.autumnRed })

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
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol_text',              -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
        maxwidth = 50,                     -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        before = function(entry, vim_item) -- for tailwind css autocomplete
          if entry.source.name == 'nvim_lsp' then
            -- Display which LSP servers this item came from.
            local lspserver_name = nil
            pcall(function()
              lspserver_name = entry.source.source.client.name
              vim_item.menu = lspserver_name
            end)
          end

          if vim_item.kind == 'Color' and entry.completion_item.documentation then
            local _, _, r, g, b = string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')
            if r then
              local color = string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
              local group = 'Tw_' .. color
              if vim.fn.hlID(group) < 1 then
                vim.api.nvim_set_hl(0, group, { fg = '#' .. color })
              end
              vim_item.kind = "ﱢ" -- or "⬤" or anything
              vim_item.kind_hl_group = group
              return vim_item
            end
          end
          vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
          return vim_item
        end
      })
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
      { name = "nvim_lsp",               max_item_count = 5 },
      { name = "nvim_lua",               max_item_count = 5 },
      { name = "ultisnips",              max_item_count = 5 },
      { name = "buffer",                 max_item_count = 5 },
      { name = "copilot", },
      { name = "nvim_lsp_signature_help" },
    }),
  })
end
