local function get_git_head()
  local head = vim.fn.FugitiveHead()
  if head == "" or head == nil then
    return "DETATCHED "
  end
  if string.len(head) > 20 then
    head = ".." .. head:sub(15)
  end
  return " " .. head
end

return {
  "nvim-lualine/lualine.nvim",
  requires = { "kyazdani42/nvim-web-devicons", opt = true },
  config = function()
    require("lualine").setup({
      options = {
        component_separators = { right = "" },
        section_separators = { left = "", right = "" },
        theme = "kanagawa",
      },
      sections = {
        lualine_a = { get_git_head },
        lualine_b = { "diff", "diagnostics" },
        lualine_c = {
          {
            "filetype",
            colored = true,   -- Displays filetype icon in color if set to true
            icon_only = true, -- Display only an icon for filetype
          },
          {
            "filename",
            file_status = true,
            path = 1,
            symbols = {
              modified = "  ",    -- Text to show when the file is modified.
              readonly = "[-]",      -- Text to show when the file is non-modifiable or readonly.
              unnamed = "[No Name]", -- Text to show for unnamed buffers.
            },
          },
          {
            require("recorder").recordingStatus
          },
          {
            require("recorder").displaySlots
          },
        },
        lualine_d = {
        },
        lualine_w = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    })
  end
}
