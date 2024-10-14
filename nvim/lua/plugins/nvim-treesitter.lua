return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
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
        enable = true,
        --disable = { "haskell" },
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end
}
