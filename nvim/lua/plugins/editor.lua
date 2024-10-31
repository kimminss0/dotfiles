return {
  { -- Oil.nvim file explorer
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons,
    config = function()
      require('oil').setup {}
      vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },

  { -- Neo-tree file system
    'nvim-neo-tree/neo-tree.nvim',
    enabled = false,
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
      enable_git_status = false,
      default_component_configs = {
        diagnostics = {
          symbols = {
            error = ' ',
            warn = ' ',
            info = ' ',
            hint = ' ',
          },
          highlight = 'NeoTreeDiagnostic',
        },
      },
    },
  },

  { -- Display a code outline window
    'stevearc/aerial.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('aerial').setup {}

      -- You probably also want to set a keymap to toggle aerial
      vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle!<CR>', { desc = 'Aerial' })
      -- vim.keymap.set("n", "<leader>ds", "<cmd>call aerial#fzf()<cr>") -- TODO: What's this?
    end,
  },

  { -- Useful plugin to show you pending keybinds.
    -- TODO: Inspect this plugin
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>h', group = 'git hunk', mode = { 'n', 'v' } },
        { '<leader>s', group = 'search' },
        { '<leader>t', group = 'toggle' },

        -- TODO: check this if it is required after the release of nvim 0.11.
        { 'gr', group = 'rename/references', mode = { 'n', 'v' } },
      },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    -- TODO: Inspect plugin
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader><C-f>', builtin.find_files, { desc = 'search files' })
      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = 'search in current buffer' })
      vim.keymap.set('n', '<leader><C-g>', builtin.live_grep, { desc = 'search by grep' })

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'help' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'keymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'files' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'select Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'current word' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'live grep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'diagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'resume search' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'recent files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>sb', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = 'search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = 'live grep in open files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'neovim files' })
    end,
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      signs_staged_enable = false,
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'stage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'reset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'stage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'undo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'reset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'preview hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'blame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'diff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'diff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'git show blame line' })
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = 'git show deleted' })
      end,
    },
  },
}
