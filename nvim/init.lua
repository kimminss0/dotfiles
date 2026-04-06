vim.opt.termguicolors = true

-- leader must be set before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true
vim.opt.undofile = true

-- Case-insensitive searching unless \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes' -- 'auto' by default

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
--vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}

-- Toggle line wrap
vim.keymap.set('n', '<leader>tw', function()
  vim.opt.wrap = not vim.o.wrap
  vim.notify('Line wrap: ' .. (vim.o.wrap and 'enabled' or 'disabled'), vim.log.levels.INFO)
end, { desc = 'Toggle line wrap' })

-- Toggle list mode
vim.keymap.set('n', '<leader>tl', function()
  vim.opt.list = not vim.o.list
  vim.notify('List mode: ' .. (vim.o.list and 'enabled' or 'disabled'), vim.log.levels.INFO)
end, { desc = 'Toggle list mode' })

-- Toggle diagnostics
vim.keymap.set('n', '<leader>td', function()
  local is_enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not is_enabled)
  vim.notify('Diagnostic: ' .. (not is_enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
end, { desc = 'Toggle diagnostics' })

-- Markdown specific configs
--vim.api.nvim_create_autocmd('FileType', {
--  pattern = { 'markdown' },
--  callback = function()
--    vim.opt_local.colorcolumn = '80'
--  end,
--})

------- Plugins --------

vim.pack.add {
  'https://github.com/navarasu/onedark.nvim',
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/tpope/vim-sleuth', -- detect indentation
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/mfussenegger/nvim-lint',
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    -- Just for clarifying; nvim-treesitter has both main and master branch.
    branch = 'main',
    build = ':TSUpdate',
  },
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/stevearc/oil.nvim',
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = vim.version.range '1.*', -- TDOO: check v2 if released
  },
  {
    src = 'https://github.com/L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
  },
  'https://github.com/rafamadriz/friendly-snippets',
}

vim.opt.bg = 'light'
vim.cmd.colorscheme 'onedark'

--------- fzf-lua ----------

vim.keymap.set('n', '<leader><leader>', function()
  vim.cmd 'FzfLua'
end, { desc = 'Execute :FzfLua' })
vim.keymap.set('n', '<leader>b', function()
  vim.cmd 'FzfLua buffers'
end, { desc = 'Show buffers' })

--------- Oil ----------

require('oil').setup {}
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

--------- Mini.nvim ---------

require('mini.pairs').setup {}
require('mini.surround').setup {}
require('mini.trailspace').setup {}
do
  local miniclue = require 'mini.clue'
  miniclue.setup {
    triggers = {
      { mode = { 'n', 'x' }, keys = '<Leader>' },
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = { 'n', 'x' }, keys = 's' },
      { mode = { 'n', 'x' }, keys = 'g' },
      { mode = { 'n', 'x' }, keys = 'z' },
      { mode = { 'n', 'x' }, keys = "'" },
      { mode = { 'n', 'x' }, keys = '`' },
      { mode = { 'n', 'x' }, keys = '"' },
      { mode = { 'i', 'c' }, keys = '<C-r>' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = '<C-w>' },
    },

    clues = {
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  }
end

--------- Snippets ---------
require('luasnip.loaders.from_vscode').lazy_load()

--------- Auto completion ----------

require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = { documentation = { auto_show = true } },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
}

--------- LSP ----------

require('mason').setup {} -- we use mason only for installing lsp servers without system package manager (brew, etc.)

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      workspace = {
        -- NOTE: slow; uncomment if needed (for neovim init.lua configuration)
        -- library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})

vim.lsp.enable { 'lua_ls', 'ts_ls', 'clangd' }

--------- Formatter ----------

require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    -- python = { "isort", "black" }, -- TODO: review
    -- go = { "goimports", "gofmt" },
    -- go = { "goimports", "gofmt", stop_after_first = true }, -- TODO: review which one is correct
    json = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    javascript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    markdown = { 'prettierd', 'prettier' },
    css = { 'prettierd', 'prettier' },
    html = { 'prettierd', 'prettier' },
    cpp = { 'clang-format' },
  },
  formatters = {
    -- biome = { require_cwd = true }, -- TODO: do we need this for biome?
  },
  format_on_save = function(bufnr)
    local ignore_filetypes = { 'sql', 'yaml', 'yml' }
    if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      return
    end
    if vim.b[bufnr].autoformat == false or vim.g.autoformat ~= true then
      return
    end
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname:match '/node_modules/' then
      return
    end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  default_format_opts = {
    lsp_format = 'fallback',
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format({ async = true }, function(err, did_edit)
    if not err and did_edit then
      vim.notify('Code formatted', vim.log.levels.INFO, { title = 'Conform' })
    end
  end)
end, { desc = 'Format buffer' })

vim.keymap.set({ 'n', 'v' }, '<leader>F', function()
  require('conform').format { formatters = { 'injected' }, timeout_ms = 3000 }
end, { desc = 'Format Injected Langs' })

-- Note that conform will fall back to LSP when no formatters are available.
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Autoformat state
-- vim.g.autoformat: global default (true/false)
-- vim.b.autoformat: buffer override (true/false/nil)

vim.g.autoformat = false

-- Disable (Global)
vim.api.nvim_create_user_command('FormatDisable', function()
  vim.g.autoformat = false
  vim.notify('Autoformat: disabled (global)', vim.log.levels.INFO)
end, { desc = 'Disable autoformat-on-save (Global)' })

-- Disable (Buffer)
vim.api.nvim_create_user_command('FormatDisableLocal', function()
  vim.b.autoformat = false
  vim.notify('Autoformat: disabled (buffer)', vim.log.levels.INFO)
end, { desc = 'Disable autoformat-on-save (Buffer)' })

-- Enable (Global)
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.g.autoformat = true
  vim.notify('Autoformat: enabled (global)', vim.log.levels.INFO)
end, { desc = 'Enable autoformat-on-save (Global)' })

-- Enable (Buffer)
vim.api.nvim_create_user_command('FormatEnableLocal', function()
  vim.b.autoformat = true
  vim.notify('Autoformat: enabled (buffer)', vim.log.levels.INFO)
end, { desc = 'Enable autoformat-on-save (Buffer)' })

-- Reset (Buffer -> follow global)
vim.api.nvim_create_user_command('FormatReset', function()
  vim.b.autoformat = nil
  vim.notify('Autoformat: reset (buffer -> global)', vim.log.levels.INFO)
end, { desc = 'Reset buffer autoformat to global' })

-- Reset (All buffers)
vim.api.nvim_create_user_command('FormatResetAll', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      vim.b[buf].autoformat = nil
    end
  end
  vim.notify('Autoformat: reset (all buffers)', vim.log.levels.INFO)
end, { desc = 'Reset autoformat for all buffers' })

vim.keymap.set('n', '<leader>tf', function()
  if vim.g.autoformat then
    vim.cmd 'FormatDisable'
  else
    vim.cmd 'FormatEnable'
  end
end, { desc = 'Toggle autoformat-on-save (Global)' })

vim.keymap.set('n', '<leader>tF', function()
  local is_enabled = vim.b.autoformat
  if is_enabled == nil then
    is_enabled = vim.g.autoformat
  end
  if is_enabled then
    vim.cmd 'FormatDisableLocal'
  else
    vim.cmd 'FormatEnableLocal'
  end
end, { desc = 'Toggle autoformat-on-save (Buffer)' })

--------- Linting ---------

require('lint').linters_by_ft = {
  -- markdown = { "vale" },
  markdown = { 'markdownlint-cli2' },
  typescript = { 'biomejs' },
}

-- Auto linting
vim.g.lint = true
do
  local M = {}
  function M.debounce(ms, fn)
    local timer = vim.uv.new_timer()
    assert(timer ~= nil)
    return function(...)
      local argv = { ... }
      timer:start(ms, 0, function()
        timer:stop()
        vim.schedule_wrap(fn)(unpack(argv))
      end)
    end
  end

  vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'BufReadPost' }, {
    group = vim.api.nvim_create_augroup('Linting', { clear = true }),
    callback = M.debounce(500, function()
      -- if not (vim.g.lint or vim.b.lint) then
      -- 	return
      -- end
      if not vim.g.lint then
        return
      end
      require('lint').try_lint()
    end),
  })
end

--------- Gitsigns ----------

require('gitsigns').setup {
  signs = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signs_staged = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signs_staged_enable = true,
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
}

vim.keymap.set('n', ']h', function()
  require('gitsigns').next_hunk()
end, { desc = 'Next git hunk' })
vim.keymap.set('n', '[h', function()
  require('gitsigns').prev_hunk()
end, { desc = 'Previous git hunk' })
vim.keymap.set('n', '<leader>hs', function()
  require('gitsigns').stage_hunk()
end, { desc = 'Stage hunk' })
vim.keymap.set('n', '<leader>hr', function()
  require('gitsigns').reset_hunk()
end, { desc = 'Reset hunk' })
vim.keymap.set('n', '<leader>hp', function()
  require('gitsigns').preview_hunk()
end, { desc = 'Preview hunk' })
vim.keymap.set('n', '<leader>hb', function()
  require('gitsigns').blame_line { full = true }
end, { desc = 'Blame line' })
vim.keymap.set('n', '<leader>hB', function()
  require('gitsigns').toggle_current_line_blame()
end, { desc = 'Toggle inline blame' })
vim.keymap.set('n', '<leader>hd', function()
  require('gitsigns').diffthis()
end, { desc = 'Diff this' })

-- vim: ts=2
