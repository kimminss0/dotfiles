return {
  {
    'cormacrelf/dark-notify',
    priority = 1001,
    config = function()
      require('dark_notify').run()
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000, -- Set higher priority to the default colorscheme
    config = function()
      require('gruvbox').setup {
        italic = {
          strings = false,
          comments = false,
          operators = false,
          folds = false,
          emphasis = true,
        },
        contrast = 'hard',
      }
      --vim.opt.background = 'light'
      vim.cmd.colorscheme 'gruvbox'
    end,
  },
  { 'shaunsingh/nord.nvim', config = false },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    opts = {
      term_colors = true,
      no_italic = true,
      -- transparent_background = true,
    },
  },
}
