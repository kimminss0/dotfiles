return {
  {
    'cormacrelf/dark-notify',
    priority = 1001,
    config = function()
      local dn = require 'dark_notify'
      dn.run()

      -- This is not lazy loaded and the below procedure takes 100 ms to
      -- load, it blocks the UI loading quite a bit.
      -- However, I don't want to see any flicker, so let's do this.
      dn.update()
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
