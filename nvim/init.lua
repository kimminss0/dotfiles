if not vim.g.vscode then
  vim.o.number = true
  vim.o.relativenumber = true

  vim.o.smartindent = true
  vim.o.expandtab = true
  vim.o.shiftwidth = 2
  vim.o.softtabstop = -1

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "make", "go" },
    command = "setlocal noexpandtab sw=0",
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    command = "setlocal colorcolumn=80",
  })

  -- Emacs-like key binding on command mode
  vim.keymap.set('c', '<C-A>', '<Home>')
  vim.keymap.set('c', '<C-E>', '<End>')
  vim.keymap.set('c', '<C-F>', '<Right>')
  vim.keymap.set('c', '<C-B>', '<Left>')
  vim.keymap.set('c', '<C-N>', '<Down>')
  vim.keymap.set('c', '<C-P>', '<Up>')
  vim.keymap.set('c', '<C-D>', '<Del>')
  vim.keymap.set('c', '<Esc><C-B>', '<S-Left>')
  vim.keymap.set('c', '<Esc><C-F>', '<S-Right>')

  vim.keymap.set('n', '<leader>w', function() vim.o.wrap = not vim.o.wrap end)
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup("plugins")
