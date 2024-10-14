vim.o.autoindent = true

vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = -1

vim.o.number = true
vim.o.relativenumber = true

-- vim.o.laststatus = 0

-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "retrobox",
--   command = "highlight link NormalFloat Normal",
-- })
-- vim.o.background = "light"
-- vim.cmd [[
-- autocmd ColorScheme retrobox highlight NormalFloat guifg=none guibg=none
-- autocmd ColorScheme retrobox highlight FloatBorder guifg=none guibg=none
-- colorscheme retrobox
-- ]]

-- 'retrobox' with bold font disabled for the Function group
vim.cmd [[

autocmd ColorScheme retrobox highlight Function gui=None
autocmd ColorScheme retrobox highlight DiagnosticInfo guifg=Gray
autocmd ColorScheme retrobox highlight DiagnosticUnderlineInfo guisp=Gray
set bg=light
colorscheme retrobox

]]
