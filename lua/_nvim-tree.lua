nnoremap(';;', ':NvimTreeToggle<CR>', 'silent')

-- Switch nvim to current directory, but only if we are editing a lue file (we are configuring vim!)
vim.cmd[[
 au BufEnter * if &ft == 'lua' | silent! cd %:p:h | endif
]]

vim.g['nvim_tree_root_folder_modifier'] = 1
vim.g['nvim_tree_highlight_opened_files'] = 1
vim.g['nvim_tree_git_hl'] = 1
vim.g['nvim_tree_indent_markers'] = 0
vim.g['nvim_tree_quit_on_open'] = 0
vim.g['nvim_tree_gitignore'] = 0
vim.g['nvim_tree_root_folder_modifier'] = ':~'
vim.g['nvim_tree_add_trailing'] = 0
vim.g['nvim_tree_group_empty'] = 1
vim.g['nvim_tree_disable_window_picker'] = 1
vim.g['nvim_tree_icon_padding'] = ' '
vim.g['nvim_tree_symlink_arrow'] = ' >> '
vim.g['nvim_tree_respect_buf_cwd'] = 1
vim.g['nvim_tree_create_in_closed_folder'] = 1
vim.g['nvim_tree_refresh_wait'] = 500

vim.cmd[[
let g:nvim_tree_window_picker_exclude = {
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }

let g:nvim_tree_show_icons = {
    \ 'git': 0,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 0,
    \ }

let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

  set termguicolors " this variable must be enabled for colors to be applied properly

  " a list of groups can be found at `:help nvim_tree_highlight`
  highlight NvimTreeFolderIcon guifg=blue
  highlight NvimTreeGitDirty guifg=#ff5f5f
  highlight NvimTreeGitStaged guifg=#c9bf00
  highlight NvimTreeGitMerge guifg=#00875f
  highlight NvimTreeGitRenamed guifg=#c9bf00
  highlight NvimTreeGitNew guifg=light#00875f

]]

require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  auto_close          = false,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  view = {
    width = 40,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {}
    }
  }
}
