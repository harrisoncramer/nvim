return {
  "nvim-lualine/lualine.nvim",
  requires = { "kyazdani42/nvim-web-devicons", opt = true },
  config = function()
    require("lualine").setup({
      options = {
        component_separators = { right = "" },
        section_separators = { left = "", right = "" },
        theme = "kanagawa",
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'branch' },
        lualine_b = {
          require("recorder").recordingStatus
        },
        lualine_c = { 'diagnostics' },
        lualine_d = {
          {
            require("recorder").recordingStatus
          },
          {
            require("recorder").displaySlots
          },
          -- lualine_z = {},
        },
        lualine_x = { 'diff' },
        lualine_y = { 'encoding', 'filetype' },
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {
          {
            "filename",
            file_status = true,
            path = 1,
            symbols = {
              modified = "  ",
              readonly = "[-]",
              unnamed = "[No Name]",
            },
          }
        },
      },
      winbar = {
        lualine_a = {
          {
            "filename",
            file_status = true,
            path = 1,
            symbols = {
              modified = "  ",
              readonly = "[-]",
              unnamed = "[No Name]",
            },
          }
        },
        lualine_b = {},
        lualine_c = { 'diagnostics' },
        lualine_x = { 'diff' },
        lualine_y = { 'progress', 'location' }
      },
    })
  end
}
