return {
  { -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('userconf-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, 'Go to definition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, 'Go to declaration')

          -- TODO: Remove these mappings after the official release of Neovim version 0.11.
          map('grn', vim.lsp.buf.rename, 'rename')
          map('grr', require('telescope.builtin').lsp_references, 'Go to references')
          map('gri', require('telescope.builtin').lsp_implementations, 'Go to implementation')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Document symbols')
          map('gra', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
          map('<C-s>', vim.lsp.buf.signature_help, 'Signature help', 'i')
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      local lspconfig = require 'lspconfig'
      lspconfig.ocamllsp.setup {}
    end,
  },
  {
    'neoclide/coc.nvim',
    enabled = false,
    branch = 'release',
    build = 'npm ci',
    config = function()
      -- https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.lua

      -- Some servers have issues with backup files, see #649
      vim.opt.backup = false
      vim.opt.writebackup = false

      -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
      -- delays and poor user experience
      vim.opt.updatetime = 300

      -- Always show the signcolumn, otherwise it would shift the text each time
      -- diagnostics appeared/became resolved
      vim.opt.signcolumn = 'yes'

      local keyset = vim.keymap.set
      -- Autocomplete
      function _G.check_back_space()
        local col = vim.fn.col '.' - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' ~= nil
      end

      -- Use Tab for trigger completion with characters ahead and navigate
      -- NOTE: There's always a completion item selected by default, you may want to enable
      -- no select by setting `"suggest.noselect": true` in your configuration file
      -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
      -- other plugins before putting this into your config
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      keyset('i', '<TAB>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
      keyset('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

      -- Make <CR> to accept selected completion item or notify coc.nvim to format
      -- <C-g>u breaks current undo, please make your own choice
      keyset('i', '<cr>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- Use <c-j> to trigger snippets
      keyset('i', '<c-j>', '<Plug>(coc-snippets-expand-jump)')
      -- Use <c-space> to trigger completion
      keyset('i', '<c-space>', 'coc#refresh()', { silent = true, expr = true })

      -- Use `[g` and `]g` to navigate diagnostics
      -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
      keyset('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
      keyset('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })

      -- GoTo code navigation
      keyset('n', 'gd', '<Plug>(coc-definition)', { silent = true })
      keyset('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
      keyset('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
      keyset('n', 'gr', '<Plug>(coc-references)', { silent = true })

      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand '<cword>'
        if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval 'coc#rpc#ready()' then
          vim.fn.CocActionAsync 'doHover'
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end
      keyset('n', 'K', '<CMD>lua _G.show_docs()<CR>', { silent = true })

      -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
      vim.api.nvim_create_augroup('CocGroup', {})
      vim.api.nvim_create_autocmd('CursorHold', {
        group = 'CocGroup',
        command = "silent call CocActionAsync('highlight')",
        desc = 'Highlight symbol under cursor on CursorHold',
      })

      -- Symbol renaming
      keyset('n', '<leader>rn', '<Plug>(coc-rename)', { silent = true })

      -- Formatting selected code
      keyset('x', '<leader>f', '<Plug>(coc-format-selected)', { silent = true })
      keyset('n', '<leader>f', '<Plug>(coc-format-selected)', { silent = true })

      -- Setup formatexpr specified filetype(s)
      vim.api.nvim_create_autocmd('FileType', {
        group = 'CocGroup',
        pattern = 'typescript,json',
        command = "setl formatexpr=CocAction('formatSelected')",
        desc = 'Setup formatexpr specified filetype(s).',
      })

      -- Apply codeAction to the selected region
      -- Example: `<leader>aap` for current paragraph
      local opts = { silent = true, nowait = true }
      keyset('x', '<leader>a', '<Plug>(coc-codeaction-selected)', opts)
      keyset('n', '<leader>a', '<Plug>(coc-codeaction-selected)', opts)

      -- Remap keys for apply code actions at the cursor position.
      keyset('n', '<leader>ac', '<Plug>(coc-codeaction-cursor)', opts)
      -- Remap keys for apply source code actions for current file.
      keyset('n', '<leader>as', '<Plug>(coc-codeaction-source)', opts)
      -- Apply the most preferred quickfix action on the current line.
      keyset('n', '<leader>qf', '<Plug>(coc-fix-current)', opts)

      -- Remap keys for apply refactor code actions.
      keyset('n', '<leader>re', '<Plug>(coc-codeaction-refactor)', { silent = true })
      keyset('x', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', { silent = true })
      keyset('n', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', { silent = true })

      -- Run the Code Lens actions on the current line
      keyset('n', '<leader>cl', '<Plug>(coc-codelens-action)', opts)

      -- Map function and class text objects
      -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
      keyset('x', 'if', '<Plug>(coc-funcobj-i)', opts)
      keyset('o', 'if', '<Plug>(coc-funcobj-i)', opts)
      keyset('x', 'af', '<Plug>(coc-funcobj-a)', opts)
      keyset('o', 'af', '<Plug>(coc-funcobj-a)', opts)
      keyset('x', 'ic', '<Plug>(coc-classobj-i)', opts)
      keyset('o', 'ic', '<Plug>(coc-classobj-i)', opts)
      keyset('x', 'ac', '<Plug>(coc-classobj-a)', opts)
      keyset('o', 'ac', '<Plug>(coc-classobj-a)', opts)

      -- Remap <C-d> and <C-u> to scroll float windows/popups
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true, expr = true }
      keyset('n', '<C-d>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-d>"', opts)
      keyset('n', '<C-u>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-u>"', opts)
      keyset('i', '<C-d>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      keyset('i', '<C-u>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      keyset('v', '<C-d>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-d>"', opts)
      keyset('v', '<C-u>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-u>"', opts)

      -- Use CTRL-S for selections ranges
      -- Requires 'textDocument/selectionRange' support of language server
      keyset('n', '<C-s>', '<Plug>(coc-range-select)', { silent = true })
      keyset('x', '<C-s>', '<Plug>(coc-range-select)', { silent = true })

      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command('Format', "call CocAction('format')", {})

      -- " Add `:Fold` command to fold current buffer
      vim.api.nvim_create_user_command('Fold', "call CocAction('fold', <f-args>)", { nargs = '?' })

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command('OR', "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

      -- Add (Neo)Vim's native statusline support
      -- NOTE: Please see `:h coc-status` for integrations with external plugins that
      -- provide custom statusline: lightline.vim, vim-airline
      vim.opt.statusline:prepend "%{coc#status()}%{get(b:,'coc_current_function','')}"

      -- Mappings for CoCList
      -- code actions and coc stuff
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true }
      -- Show all diagnostics
      keyset('n', '<space>a', ':<C-u>CocList diagnostics<cr>', opts)
      -- Manage extensions
      keyset('n', '<space>e', ':<C-u>CocList extensions<cr>', opts)
      -- Show commands
      keyset('n', '<space>c', ':<C-u>CocList commands<cr>', opts)
      -- Find symbol of current document
      keyset('n', '<space>o', ':<C-u>CocList outline<cr>', opts)
      -- Search workspace symbols
      keyset('n', '<space>s', ':<C-u>CocList -I symbols<cr>', opts)
      -- Do default action for next item
      keyset('n', '<space>j', ':<C-u>CocNext<cr>', opts)
      -- Do default action for previous item
      keyset('n', '<space>k', ':<C-u>CocPrev<cr>', opts)
      -- Resume latest coc list
      keyset('n', '<space>p', ':<C-u>CocListResume<cr>', opts)
    end,
  },
}
