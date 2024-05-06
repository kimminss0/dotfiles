return {
  "junegunn/fzf",
  config = function(_, opts)
    vim.opt.rtp:append {"/usr/bin/fzf"}
  end
}
