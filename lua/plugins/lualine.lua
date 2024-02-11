local u = require("functions.utils")
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

local default_filename = {
  {
    "filename",
    file_status = true,
    path = 2,
    symbols = {
      modified = "  ",
      readonly = "[-]",
      unnamed = "[No Name]",
    },
  }
}

local filename = function()
  local git_root = u.get_root_git_dir()
  if git_root == nil then return default_filename end
  local full_file_path = vim.fn.expand('%:p')
  local escaped_git_root = git_root:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
  local res = full_file_path:gsub(escaped_git_root, "", 1)
  return res
end


local diagnostics = {
  {
    'diagnostics',
    symbols = { error = "✘ ", warn = " ", hint = " ", info = " " },
  }
}

local disabled_filetypes = { 'gitlab', 'DiffviewFiles', "oil" }

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
  config = function()
    require("lualine").setup({
      options = {
        disabled_filetypes = {
          winbar = disabled_filetypes,
          statusline = disabled_filetypes,
        },
        component_separators = { right = "" },
        section_separators = { left = "", right = "" },
        theme = "kanagawa",
        globalstatus = true,
      },
      sections = {
        lualine_a = { get_git_head },
        lualine_b = {
          filename,
          require("recorder").recordingStatus
        },
        lualine_c = diagnostics,
        lualine_d = { 'tabs' },
        lualine_x = { 'diff' },
        lualine_y = { 'encoding', 'filetype', },
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = { filename },
      },
      winbar = {
        lualine_a = { filename },
        lualine_b = {},
        lualine_c = diagnostics,
        lualine_x = { 'diff' },
        lualine_y = { 'progress', 'location' }
      },
    })
  end
}
