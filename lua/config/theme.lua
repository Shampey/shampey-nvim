local M = {}

local scheme = 'palenightfall'

function M.apply()
  vim.cmd('colorscheme ' .. scheme)

  local custom_lualine = require 'lualine.themes.auto'
  local ok, theme = pcall(require, scheme)
  local colors = ok and theme.colors or nil
  if colors and colors.blue and colors.background and colors.statusline and colors.foreground_darker then
    custom_lualine.normal.a = {
      bg = colors.blue,
      fg = colors.background,
      gui = 'bold',
    }
    custom_lualine.inactive = {
      a = { bg = colors.statusline, fg = colors.foreground_darker, gui = 'bold' },
      b = { bg = colors.statusline, fg = colors.foreground_darker },
      c = { bg = colors.statusline, fg = colors.foreground_darker },
    }
  end

  require('lualine').setup {
    options = {
      theme = custom_lualine,
    },
    sections = {
      lualine_a = { { 'mode', color = { gui = 'bold' } } },
      lualine_b = { 'diff', 'diagnostics' },
      lualine_c = {},
      lualine_x = {},
      lualine_y = { 'filetype' },
      lualine_z = { 'location' },
    },
    tabline = {
      lualine_a = { { 'buffers', symbols = { alternate_file = '' } } },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  }
end

-- make things transparent
-- vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' }) -- if transparent terminal
-- vim.cmd [[
--   highlight Normal guibg=NONE ctermbg=NONE
--   highlight NormalNC guibg=NONE ctermbg=NONE
--   highlight SignColumn guibg=NONE ctermbg=NONE
--   highlight LineNr guibg=NONE ctermbg=NONE
--   highlight CursorLineNr guibg=NONE ctermbg=NONE
--   highlight FoldColumn guibg=NONE ctermbg=NONE
--   highlight EndOfBuffer guibg=NONE ctermbg=NONE
-- ]]

return M
