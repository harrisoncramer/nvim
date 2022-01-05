return {
  setup = function (remap)
    remap({'x', 'iu', ':lua require"treesitter-unit".select()<CR>'})
    remap({'x', 'au', ':lua require"treesitter-unit".select(true)<CR>'})
    remap({'o', 'iu', ':<c-u>lua require"treesitter-unit".select()<CR>'})
    remap({'o', 'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>'})
  end
}
