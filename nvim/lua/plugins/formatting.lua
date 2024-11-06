return {
  { -- better formatting than lsp
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = 'format buffer',
      },
    },
    opts = function()
      ---@param bufnr integer
      ---@param ... string
      ---@return string
      local function first(bufnr, ...)
        local conform = require 'conform'
        for i = 1, select('#', ...) do
          local formatter = select(i, ...)
          if conform.get_formatter_info(formatter, bufnr).available then
            return formatter
          end
        end
        return select(1, ...)
      end

      -- This will provide type hinting with LuaLS
      ---@module "conform"
      ---@type conform.setupOpts
      return {
        notify_on_error = false,
        format_on_save = function(bufnr)
          -- Disable for some filetypes
          local filetype_disable_format_on_save = { markdown = true }
          if filetype_disable_format_on_save[vim.bo[bufnr].filetype] then
            return
          end

          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local filetype_disable_lsp_fallback = { c = true, cpp = true }
          local lsp_format_opt
          if filetype_disable_lsp_fallback[vim.bo[bufnr].filetype] then
            lsp_format_opt = 'never'
          else
            lsp_format_opt = 'fallback'
          end
          return {
            timeout_ms = 500,
            lsp_format = lsp_format_opt,
          }
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          -- Conform can also run multiple formatters sequentially
          python = { 'isort', 'black' },
          -- You can use 'stop_after_first' to run the first available formatter from the list
          javascript = { 'prettierd', 'prettier', stop_after_first = true },

          -- markdown = function(bufnr)
          -- 	return { first(bufnr, "prettierd", "prettier"), "injected" }
          -- end,
          markdown = { 'prettierd', 'prettier' },

          css = { 'prettierd', 'prettier' },

          go = { 'gofmt' }, -- TODO: chain 'goimport', etc? is 'goimport' included in 'gofmt'?
        },
      }
    end,
    init = function()
      -- The conform formatexpr should fall back to LSP when no formatters are available, and fall back to
      -- the internal default if no LSP clients are available. So it should be safe to set it globally.
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
