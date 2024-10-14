vim.api.nvim_create_autocmd("FileType", {
  pattern = { "make", "go" },
  command = "setlocal noexpandtab sw=0",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  command = "setlocal colorcolumn=80",
})
