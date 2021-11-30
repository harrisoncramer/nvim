require('lualine').setup({
  options = {theme = 'gruvbox-material'},
    sections = {
      lualine_x = {'filetype'},
      lualine_y = {'progress'},
      lualine_z = {}
  },
})
