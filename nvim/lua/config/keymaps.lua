--vim.keymap.set("n", "<leader>b", "<cmd>buffers<cr>:b<space>")

vim.cmd [[
cnoremap <C-A>		<Home>
cnoremap <C-B>		<Left>
cnoremap <C-D>		<Del>
cnoremap <C-E>		<End>
cnoremap <C-F>		<Right>
cnoremap <C-N>		<Down>
cnoremap <C-P>		<Up>
cnoremap <Esc><C-B>	<S-Left>
cnoremap <Esc><C-F>	<S-Right>

nnoremap <leader>w	<cmd>set wrap!<cr>
]]
