return {
  {
    'RRethy/base16-nvim',
    lazy = true,
    priority = 1000,
  },
  {
    'mcncl/alabaster.nvim',
    lazy = true,
    priority = 1000,
  },
  {
    'JoosepAlviste/palenightfall.nvim',
    lazy = false,
    priority = 1000,
  },
  {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 1000,
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = true,
    priority = 1000,
  },
  {
    'nkxxll/ghostty-default-style-dark.nvim',
    lazy = true,
    priority = 1000,
    config = function() require('ghostty-default-style-dark').setup {} end,
  },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = true,
  },
  {
    'navarasu/onedark.nvim',
    lazy = true,
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'warm',
      }
      require('onedark').load()
    end,
  },
  {
    'rose-pine/neovim',
    lazy = true,
    priority = 1000,
  },
  {
    'catppuccin/nvim',
    lazy = true,
    priority = 1000,
  },
  {
    'sainnhe/sonokai',
    lazy = true,
    priority = 1000,
    config = function() vim.g.sonokai_enable_italic = true end,
  },
  {
    'loctvl842/monokai-pro.nvim',
    lazy = true,
    priority = 1000,
    config = function()
      require('monokai-pro').setup {
        filter = 'ristretto',
      }
    end,
  },
}
