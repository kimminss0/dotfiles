return {
  { -- Status line
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local M = require('lualine.component'):extend()

      do
        M.processing = false
        M.spinner_index = 1

        local spinner_symbols = {
          '⠋',
          '⠙',
          '⠹',
          '⠸',
          '⠼',
          '⠴',
          '⠦',
          '⠧',
          '⠇',
          '⠏',
        }
        local spinner_symbols_len = 10

        -- Initializer
        function M:init(options)
          M.super.init(self, options)

          local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})

          vim.api.nvim_create_autocmd({ 'User' }, {
            pattern = 'CodeCompanionRequest*',
            group = group,
            callback = function(request)
              if request.match == 'CodeCompanionRequestStarted' then
                self.processing = true
              elseif request.match == 'CodeCompanionRequestFinished' then
                self.processing = false
              end
            end,
          })
        end

        -- Function that runs every time statusline is updated
        function M:update_status()
          if self.processing then
            self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
            return spinner_symbols[self.spinner_index]
          else
            return nil
          end
        end
      end

      require('lualine').setup {
        options = { section_separators = '', component_separators = '' },
        -- options = { section_separators = '', component_separators = '│' },
        sections = {
          lualine_x = { M },
        },
      }
    end,
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
}
