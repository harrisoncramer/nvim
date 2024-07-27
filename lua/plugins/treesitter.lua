return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    -- "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "andymass/vim-matchup",
  },
  config = function()
    -- For rainbow brackets
    local enabled_list = { "clojure" }
    local parsers = require("nvim-treesitter.parsers")

    local disable_function = function(lang, bufnr)
      if not bufnr then
        bufnr = 0
      end

      if lang == "help" then
        return true
      end

      local buf_name = vim.fn.expand("%")
      if lang == "clojure" and string.find(buf_name, "conjure%-") then
        return true
      end


      -- local line_count = vim.api.nvim_buf_line_count(bufnr)
      -- if line_count > 500 or (line_count == 1 and lang == "json") then
      --   vim.g.matchup_matchparen_enabled = 0
      --   return true
      -- else
      --   return false
      -- end
    end

    require("nvim-treesitter.configs")
        .setup({
          incremental_selection = {
            enable = true,
            keymaps = {
              node_incremental = "v",
              node_decremental = "V",
            },
          },
          modules = {},
          auto_install = false,
          ignore_install = {},
          ensure_installed = { "javascript", "typescript", "go", "vue", "clojure", "lua", "css", "bash", "json", "sql",
            "dockerfile", "html", "python", "scss", "rust", "markdown", "hcl", "astro", "tsx", "terraform" },
          sync_install = false,
          indent = {
            enable = true
          },
          autotag = {
            enable = true
          },
          highlight = {
            enable = true,
            disable = disable_function,
            additional_vim_regex_highlighting = false,
          },
          -- Rainbow parens plugin
          rainbow = {
            enable = true,
            -- Enable only for lisp like languages
            disable = vim.tbl_filter(function(p)
              local disable = true
              for _, lang in pairs(enabled_list) do
                if p == lang then
                  disable = false
                end
              end
              return disable
            end, parsers.available_parsers()),
          },
          matchup = {
            enable = true,
            disable = { "json", "csv" },
          },
          playground = {
            enable = true,
            disable = {},
            updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
              toggle_query_editor = "o",
              toggle_hl_groups = "i",
              toggle_injected_languages = "t",
              toggle_anonymous_nodes = "a",
              toggle_language_display = "I",
              focus_language = "f",
              unfocus_language = "F",
              update = "R",
              goto_node = "<cr>",
              show_help = "?",
            },
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = { query = "@function.outer", desc = "All of a function definition" },
                ["if"] = { query = "@function.inner", desc = "Inner part of a function definition" },
                ["ac"] = { query = "@comment.outer", desc = "All of a comment" },
              },
              selection_modes = {
                ['@function.outer'] = 'V', -- linewise
              },
              -- If you set this to `true` (default is `false`) then any textobject is
              -- extended to include preceding or succeeding whitespace.
              include_surrounding_whitespace = true,
            },
          },
          context = {
            enable = false,
            max_lines = 0,        -- How many lines the window should span. Values <= 0 mean no limit.
            trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            patterns = {
              -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
              -- For all filetypes
              -- Note that setting an entry here replaces all other patterns for this entry.
              -- By setting the 'default' entry below, you can control which nodes you want to
              -- appear in the context window.
              default = {
                "class",
                "function",
                "method",
                "for",
                "while",
                "if",
                "switch",
                "case",
              },
              -- Patterns for specific filetypes
              -- If a pattern is missing, *open a PR* so everyone can benefit.
              tex = {
                "chapter",
                "section",
                "subsection",
                "subsubsection",
              },
              rust = {
                "impl_item",
                "struct",
                "enum",
              },
              scala = {
                "object_definition",
              },
              vhdl = {
                "process_statement",
                "architecture_body",
                "entity_declaration",
              },
              markdown = {
                "section",
              },
              elixir = {
                "anonymous_function",
                "arguments",
                "block",
                "do_block",
                "list",
                "map",
                "tuple",
                "quoted_content",
              },
            },
            exact_patterns = {},
            zindex = 20,     -- The Z-index of the context window
            mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
            -- Separator between context and content. Should be a single character string, like '-'.
            -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
            separator = nil,
          }
        })

    vim.treesitter.language.register("markdown", "mdx")

    -- Delimeter colors
    -- Find a way to exclude template sections + jsx only???
    -- local colors = require("colorscheme")
    -- vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = colors.carpYellow })
    -- vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = colors.lightBlue })
    -- vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = colors.springGreen })
    -- vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = colors.oniViolet })
    -- vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = colors.crystalBlue })
    -- require('rainbow-delimiters.setup').setup {
    --   strategy = {
    --     -- ...
    --   },
    --   query = {
    --     -- ...
    --   },
    --   highlight = {
    --     'RainbowDelimiterYellow',
    --     'RainbowDelimiterBlue',
    --     'RainbowDelimiterGreen',
    --     'RainbowDelimiterViolet',
    --     'RainbowDelimiterCyan',
    --   },
    -- }
  end
}
