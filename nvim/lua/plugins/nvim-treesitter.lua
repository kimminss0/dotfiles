return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local highlight_enable = not vim.g.vscode
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c",
        "cpp",
        "go",
        "haskell",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "javascript",
        "typescript",
        "html",
      },
      sync_install = false,
      highlight = {
        enable = highlight_enable,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = { "markdown" },
      },
    })
  end
}
