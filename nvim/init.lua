--[[
NOTE: The upcoming Neovim release (version 0.11) will introduce the following mappings:

Mappings:
  • |grn| in Normal mode maps to |vim.lsp.buf.rename()|
  • |grr| in Normal mode maps to |vim.lsp.buf.references()|
  • |gri| in Normal mode maps to |vim.lsp.buf.implementation()|
  • |gO| in Normal mode maps to |vim.lsp.buf.document_symbol()|
  • |gra| in Normal and Visual modes maps to |vim.lsp.buf.code_action()|
  • CTRL-S in Insert mode maps to |vim.lsp.buf.signature_help()|
  • Mouse |popup-menu| includes an "Open in web browser" item when right-clicking a URL.
  • Mouse |popup-menu| includes a "Go to definition" item when LSP is active in the buffer.

Additional mappings inspired by Tim Pope's vim-unimpaired:
  • |[q|, |]q|, |[Q|, |]Q|, |[CTRL-Q|, |]CTRL-Q| navigate the |quickfix| list.
  • |[l|, |]l|, |[L|, |]L|, |[CTRL-L|, |]CTRL-L| navigate the |location-list|.
  • |[t|, |]t|, |[T|, |]T|, |[CTRL-T|, |]CTRL-T| navigate the |tag-matchlist|.
  • |[a|, |]a|, |[A|, |]A| navigate the |argument-list|.
  • |[b|, |]b|, |[B|, |]B| navigate the |buffer-list|.

I've added these mappings temporarily until version 0.11 is released.

TODO: Remove these mappings after the official release.
]]

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true
-- Make line numbers relative to the cursor
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- VSCode specific setting
if vim.g.vscode then
  require 'configs/vscode'
end

-- Emacs-like key binding on command mode
--  TODO: add <C-U>, <C-K>
vim.keymap.set('c', '<C-A>', '<Home>')
vim.keymap.set('c', '<C-E>', '<End>')
vim.keymap.set('c', '<C-F>', '<Right>')
vim.keymap.set('c', '<C-B>', '<Left>')
vim.keymap.set('c', '<C-N>', '<Down>')
vim.keymap.set('c', '<C-P>', '<Up>')
vim.keymap.set('c', '<C-D>', '<Del>')

-- Toggle line wrapping
vim.keymap.set('n', '<leader>tw', function()
  vim.opt.wrap = not vim.o.wrap
end, { desc = 'line wrap' })

-- vim-unimpaired style mappings.
--- See: https://github.com/tpope/vim-unimpaired
--- TODO: Remove these mappings after the official release of nvim 0.11.
--- {{{
do
  --- Execute a command and print errors without a stacktrace.
  --- @param opts table Arguments to |nvim_cmd()|
  local function cmd(opts)
    local _, err = pcall(vim.api.nvim_cmd, opts, {})
    if err then
      vim.api.nvim_err_writeln(err:sub(#'Vim:' + 1))
    end
  end

  -- Quickfix mappings
  vim.keymap.set('n', '[q', function()
    cmd { cmd = 'cprevious', count = vim.v.count1 }
  end, { desc = ':cprevious' })

  vim.keymap.set('n', ']q', function()
    cmd { cmd = 'cnext', count = vim.v.count1 }
  end, { desc = ':cnext' })

  vim.keymap.set('n', '[Q', function()
    cmd { cmd = 'crewind', count = vim.v.count ~= 0 and vim.v.count or nil }
  end, { desc = ':crewind' })

  vim.keymap.set('n', ']Q', function()
    cmd { cmd = 'clast', count = vim.v.count ~= 0 and vim.v.count or nil }
  end, { desc = ':clast' })

  vim.keymap.set('n', '[<C-Q>', function()
    cmd { cmd = 'cpfile', count = vim.v.count1 }
  end, { desc = ':cpfile' })

  vim.keymap.set('n', ']<C-Q>', function()
    cmd { cmd = 'cnfile', count = vim.v.count1 }
  end, { desc = ':cnfile' })

  -- Location list mappings
  vim.keymap.set('n', '[l', function()
    cmd { cmd = 'lprevious', count = vim.v.count1 }
  end, { desc = ':lprevious' })

  vim.keymap.set('n', ']l', function()
    cmd { cmd = 'lnext', count = vim.v.count1 }
  end, { desc = ':lnext' })

  vim.keymap.set('n', '[L', function()
    cmd { cmd = 'lrewind', count = vim.v.count ~= 0 and vim.v.count or nil }
  end, { desc = ':lrewind' })

  vim.keymap.set('n', ']L', function()
    cmd { cmd = 'llast', count = vim.v.count ~= 0 and vim.v.count or nil }
  end, { desc = ':llast' })

  vim.keymap.set('n', '[<C-L>', function()
    cmd { cmd = 'lpfile', count = vim.v.count1 }
  end, { desc = ':lpfile' })

  vim.keymap.set('n', ']<C-L>', function()
    cmd { cmd = 'lnfile', count = vim.v.count1 }
  end, { desc = ':lnfile' })

  -- Argument list
  vim.keymap.set('n', '[a', function()
    cmd { cmd = 'previous', count = vim.v.count1 }
  end, { desc = ':previous' })

  vim.keymap.set('n', ']a', function()
    -- count doesn't work with :next, must use range. See #30641.
    cmd { cmd = 'next', range = { vim.v.count1 } }
  end, { desc = ':next' })

  vim.keymap.set('n', '[A', function()
    if vim.v.count ~= 0 then
      cmd { cmd = 'argument', count = vim.v.count }
    else
      cmd { cmd = 'rewind' }
    end
  end, { desc = ':rewind' })

  vim.keymap.set('n', ']A', function()
    if vim.v.count ~= 0 then
      cmd { cmd = 'argument', count = vim.v.count }
    else
      cmd { cmd = 'last' }
    end
  end, { desc = ':last' })

  -- Tags
  vim.keymap.set('n', '[t', function()
    -- count doesn't work with :tprevious, must use range. See #30641.
    cmd { cmd = 'tprevious', range = { vim.v.count1 } }
  end, { desc = ':tprevious' })

  vim.keymap.set('n', ']t', function()
    -- count doesn't work with :tnext, must use range. See #30641.
    cmd { cmd = 'tnext', range = { vim.v.count1 } }
  end, { desc = ':tnext' })

  vim.keymap.set('n', '[T', function()
    -- count doesn't work with :trewind, must use range. See #30641.
    cmd { cmd = 'trewind', range = vim.v.count ~= 0 and { vim.v.count } or nil }
  end, { desc = ':trewind' })

  vim.keymap.set('n', ']T', function()
    -- :tlast does not accept a count, so use :trewind if count given
    if vim.v.count ~= 0 then
      cmd { cmd = 'trewind', range = { vim.v.count } }
    else
      cmd { cmd = 'tlast' }
    end
  end, { desc = ':tlast' })

  vim.keymap.set('n', '[<C-T>', function()
    -- count doesn't work with :ptprevious, must use range. See #30641.
    cmd { cmd = 'ptprevious', range = { vim.v.count1 } }
  end, { desc = ' :ptprevious' })

  vim.keymap.set('n', ']<C-T>', function()
    -- count doesn't work with :ptnext, must use range. See #30641.
    cmd { cmd = 'ptnext', range = { vim.v.count1 } }
  end, { desc = ':ptnext' })

  -- Buffers
  vim.keymap.set('n', '[b', function()
    cmd { cmd = 'bprevious', count = vim.v.count1 }
  end, { desc = ':bprevious' })

  vim.keymap.set('n', ']b', function()
    cmd { cmd = 'bnext', count = vim.v.count1 }
  end, { desc = ':bnext' })

  vim.keymap.set('n', '[B', function()
    if vim.v.count ~= 0 then
      cmd { cmd = 'buffer', count = vim.v.count }
    else
      cmd { cmd = 'brewind' }
    end
  end, { desc = ':brewind' })

  vim.keymap.set('n', ']B', function()
    if vim.v.count ~= 0 then
      cmd { cmd = 'buffer', count = vim.v.count }
    else
      cmd { cmd = 'blast' }
    end
  end, { desc = ':blast' })
end
-- }}}

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('userconf-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Markdown specific configs
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown' },
  callback = function()
    vim.opt_local.colorcolumn = '80'
  end,
})

-- Define Icons for diagnostic errors
vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = ' ', texthl = 'DiagnosticSignHint' })

-- [[ Install `lazy.nvim` plugin manager ]]
--- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup 'plugins'

-- vim: ts=2 sts=2 sw=2 et foldmethod=marker
