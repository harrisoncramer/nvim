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

local filename = {
  {
    "filename",
    file_status = true,
    path = 0,
    symbols = {
      modified = "  ",
      readonly = "[-]",
      unnamed = "[No Name]",
    },
  }
}

local diagnostics = {
  {
    'diagnostics',
    symbols = { error = "✘ ", warn = " ", hint = " ", info = " " },
  }
}

local disabled_filetypes = { 'gitlab', 'DiffviewFiles', "oil" }

return {
  "nvim-lualine/lualine.nvim",
  requires = { "kyazdani42/nvim-web-devicons", opt = true },
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
          require("recorder").recordingStatus
        },
        lualine_c = diagnostics,
        lualine_d = { 'tabs' },
        lualine_x = { 'diff' },
        lualine_y = { 'encoding', 'filetype', },
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = filename,
      },
      winbar = {
        lualine_a = filename,
        lualine_b = {},
        lualine_c = diagnostics,
        lualine_x = { 'diff' },
        lualine_y = { 'progress', 'location' }
      },
    })
  end
}
