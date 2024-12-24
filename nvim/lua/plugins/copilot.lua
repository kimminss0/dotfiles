return {
  {
    'zbirenbaum/copilot.lua',
    enabled = true,
    config = function()
      require('copilot').setup {
        suggestion = {
          auto_trigger = true,
        },
      }
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
      'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
      {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = {
          -- 'markdown',
          'codecompanion',
        },
      },
    },
    keys = {
      { '<leader>ca', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'actions' },
      { '\\', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'toggle chat' },
      { '<C-\\>', '<cmd>CodeCompanionChat Toggle<cr>', mode = 'i', desc = 'toggle chat' },
      { 'ga', '<cmd>CodeCompanionChat Add<cr>', mode = 'v', desc = 'add to chat' },
    },
    opts = {
      language = 'English',
      adapters = {
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            env = {
              api_key = vim.env.ANTHROPIC_API_KEY,
            },
          })
        end,
        ollama = function()
          return require('codecompanion.adapters').extend('ollama', {
            env = {
              url = 'http://ollama.mskim.cc',
            },
            schema = {
              model = {
                -- default = 'deepseek-coder-v2:16b',
                default = 'hhao/qwen2.5-coder-20241107:7b-q8_0',
              },
              num_ctx = {
                default = 8192,
              },
              num_predict = {
                default = -1,
              },
            },
            parameters = {
              sync = true,
            },
          })
        end,
        openrouter = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = {
              url = 'https://openrouter.ai/api',
              api_key = vim.env.OPENROUTER_API_KEY,
              chat_url = '/v1/chat/completions',
            },
            schema = {
              model = {
                -- default = 'qwen/qwen-2.5-coder-32b-instruct',
                default = 'anthropic/claude-3.5-sonnet',
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'anthropic',
        },
        inline = {
          adapter = 'anthropic',
        },
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    enabled = false,
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    config = function()
      require('CopilotChat.integrations.cmp').setup()
      require('CopilotChat').setup {
        debug = true,
        -- See Configuration section for rest
      }
    end,
    -- See Commands section for default commands if you want to lazy load on them
  },
}
