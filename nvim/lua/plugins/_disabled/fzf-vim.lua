return {
  "junegunn/fzf.vim",
  config = function(_, opts)
    vim.keymap.set("n", "<c-p>", "<cmd>GFiles<cr>")
    vim.keymap.set("n", "<c-g>", "<cmd>Rg<cr>")
    -- vim.keymap.set("n", "<leader>b", "<cmd>Buffers<cr>")
  end
}
