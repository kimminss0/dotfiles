return { -- Oil.nvim file explorer
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons,
  config = function()
    require('oil').setup {}
    vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })
  end,
}
