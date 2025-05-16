return {
  "folke/which-key.nvim",
  lazy = false,

  opts = {},

  keys = {
    { "<leader>tt", require("fzf-lua").tmux_buffers, desc = "List Tmux Paste Buffer", mode = "n" },
  },
}
