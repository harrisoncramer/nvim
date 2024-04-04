local u = require("functions.utils")
local git = require("git-helpers")

local function get_git_head()
  local head = vim.fn.FugitiveHead()
  if head == "" or head == nil then
    return "DETATCHED "
  end
  if string.len(head) > 20 then
    head = ".." .. head:sub(15)
  end
  return " " .. head
end

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

local get_pipeline_icon = function(info)
  if not info.pipeline or info.pipeline == vim.NIL then
    return ""
  end
  local icon_symbols = require("gitlab").state.settings.pipeline
  local symbol = icon_symbols[info.pipeline.status]
  if info.pipeline.status == 'failed' then
    return "%#DiagnosticError#" .. symbol
  end
  if info.pipeline.status == 'success' then
    return "%#DiagnosticOk#" .. symbol
  end
  return "%#DiagnosticWarn#" .. symbol
end

local mr_info = ""
local pipeline_icon = ""
local is_gitlab_mr = nil

local timer = vim.loop.new_timer()
timer:start(0, 10000, vim.schedule_wrap(function()
  if is_gitlab_mr == nil then
    is_gitlab_mr = require("git-helpers").is_gitlab_mr()
  end

  if not is_gitlab_mr then
    return
  end
  require("gitlab").data({ { type = "info", refresh = true } }, function(data)
    mr_info = string.format("  '%s' by %s", data.info.title, data.info.author.username)
    pipeline_icon = get_pipeline_icon(data.info)
  end)
end))

local get_mr_info = {
  function()
    return mr_info .. "  " .. pipeline_icon .. "  "
  end,
  padding = { left = 0, right = 0 }, -- Adjust padding as needed
}

local diagnostics = { 'diagnostics' }

local disabled_filetypes = { 'gitlab', 'DiffviewFiles', "oil" }

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
        lualine_a = { get_git_head },
        lualine_b = {
          filename,
          require("recorder").recordingStatus
        },
        lualine_c = { diagnostics },
        lualine_x = { get_mr_info, 'diff' },
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
        lualine_y = { 'progress', 'location' }
      },
    })
  end
}
