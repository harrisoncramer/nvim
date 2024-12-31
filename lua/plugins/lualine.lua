local u = require("functions.utils")
local git = require("git-helpers")

local function get_git_head()
  local head = vim.fn.trim(vim.fn.system({ "git", "branch", "--show-current" }))
  if vim.v.shell_error ~= 0 or head == "" or head == nil then
    return "DETATCHED "
  end
  if string.len(head) > 20 then
    head = ".." .. head:sub(15)
  end
  return " " .. head
end

vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "FocusGained" }, {
  callback = function()
    vim.g.branch_name = get_git_head()
  end
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lualine")
  end
})

local filename = function()
  local git_root = git.get_root_git_dir()
  local modified = vim.api.nvim_buf_get_option(0, 'modified')
  local readonly = vim.api.nvim_buf_get_option(0, 'readonly')
  if git_root == nil then
    local base_file = u.basename(vim.api.nvim_buf_get_name(0))
    return base_file .. (modified and '  ' or '') .. (readonly and ' [-]' or '')
  end
  local full_file_path = vim.fn.expand('%:p')
  local escaped_git_root = git_root:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
  return full_file_path:gsub(escaped_git_root, "", 1) .. (modified and '  ' or '') .. (readonly and ' [-]' or '')
end

local ollama = function()
  local status = require("ollama").status()
  if status == "IDLE" then
    return "󱙺" -- nf-md-robot-outline
  elseif status == "WORKING" then
    return "󰚩" -- nf-md-robot
  end
end

local diagnostics = { 'diagnostics' }
local disabled_filetypes = { 'gitlab', 'DiffviewFiles', "oil" }

local mode_map = {
  n = "(ᴗ_ ᴗ。)",
  i = "( •̯́ ₃ •̯̀)",
  R = "( ⌐■_■)",
  v = "(⊙ _ ⊙ )",
  V = "(⊙ _ ⊙ )",
  no = "(•̀ - •́ )",
  ['!'] = "(•̀ - •́ )",
  c = "(•̀ - •́ )",
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
  config = function()
    local colorscheme = require("colorscheme")
    local custom_kanagawa = require('lualine.themes.kanagawa')
    custom_kanagawa.normal.c.fg = colorscheme.surimiOrange
    custom_kanagawa.normal.c.bg = colorscheme.sumiInk1

    require("lualine").setup({
      options = {
        disabled_filetypes = {
          winbar = disabled_filetypes,
          statusline = disabled_filetypes,
        },
        component_separators = { right = "" },
        section_separators = { left = "", right = "" },
        theme = custom_kanagawa,
        globalstatus = true,
        refresh = {
          statusline = 10000,
        }
      },
      sections = {
        lualine_a = { function() return vim.g.branch_name end },
        lualine_b = {
          filename,
          require("recorder").recordingStatus,
          ollama,
        },
        lualine_c = { diagnostics },
        lualine_x = { 'diff' },
        lualine_y = { 'progress', 'encoding', 'filetype', },
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = { filename },
        lualine_c = {},
        lualine_x = {},
      },
      winbar = {
        lualine_a = { filename },
        lualine_b = {},
        lualine_c = { diagnostics },
        lualine_x = { 'diff' },
        lualine_y = { 'progress', 'location' },
        lualine_z = {
          {
            "mode",
            icons_enabled = true,
            fmt = function()
              return mode_map[vim.api.nvim_get_mode().mode] or vim.api.nvim_get_mode().mode
            end
          }
        }
      },
    })
  end
}
