return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup {}

    vim.keymap.set("n", "<c-p>", function() require('fzf-lua').files() end)
    vim.keymap.set("n", "<c-g>", function() require('fzf-lua').live_grep() end)
    vim.keymap.set("n", "<c-f>", function() require('fzf-lua').lgrep_curbuf() end)
    vim.keymap.set("n", "<leader>b", function() require('fzf-lua').buffers() end)
    vim.keymap.set("n", "<leader>f", function() require('fzf-lua').builtin() end)
  end
}
