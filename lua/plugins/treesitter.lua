return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      local parsers = { 'bash', 'c', 'diff', 'java', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(parsers)

      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          local bracket_color = '#939293'
          vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = bracket_color })
          vim.api.nvim_set_hl(0, '@punctuation.special', { fg = bracket_color })
          vim.api.nvim_set_hl(0, '@constructor.lua', { fg = bracket_color })
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end
          if not vim.treesitter.language.add(language) then return end

          vim.treesitter.start(buf, language)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = { lsp = { enabled = true } },
    },
  },
}
