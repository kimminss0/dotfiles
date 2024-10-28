return {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('gruvbox').setup({
      italic = {
        strings = false,
        comments = false,
        -- emphasis = false,
      },
      contrast = "hard",
    })
    vim.cmd.colorscheme 'gruvbox'
  end,
}
