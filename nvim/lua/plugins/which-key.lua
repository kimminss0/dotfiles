return { -- Useful plugin to show you pending keybinds.
  -- TODO: Inspect this plugin
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  opts = {
    icons = { mappings = false },

    -- Document existing key chains
    spec = {
      { '<leader>h', group = 'git hunk', mode = { 'n', 'v' } },
      { '<leader>s', group = 'search' },
      { '<leader>t', group = 'toggle' },
      { '<leader>c', group = 'code companion' },

      -- TODO: check this if it is required after the release of nvim 0.11.
      { 'gr', group = 'rename/references', mode = { 'n', 'v' } },
    },
  },
}
