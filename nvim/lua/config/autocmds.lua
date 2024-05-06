vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  command = "setlocal noexpandtab",
})
