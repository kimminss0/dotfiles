return {
--  {
--    "rakr/vim-one",
--    priority = 1000, -- make sure to load this before all the other start plugins
--    config = function()
--      vim.cmd.colorscheme 'one'
--    end
--  },
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup {
        style = 'darker'
      }
      -- Enable theme
      require('onedark').load()
    end
  },
  {
    'ellisonleao/gruvbox.nvim',
    -- priority = 1000, -- Set higher priority to the default colorscheme
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
      --vim.cmd.colorscheme 'gruvbox'
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
