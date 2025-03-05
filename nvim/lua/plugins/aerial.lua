return { -- Display a code outline window
  'stevearc/aerial.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('aerial').setup {}

    -- You probably also want to set a keymap to toggle aerial
    vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle!<CR>', { desc = 'Aerial' })
    -- vim.keymap.set("n", "<leader>ds", "<cmd>call aerial#fzf()<cr>") -- TODO: What's this?
  end,
}
