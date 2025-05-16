return {
  "folke/which-key.nvim",
  lazy = false,

  config = function()
    local wk = require("which-key")
    wk.add({
      { "<leader><tab>", ":tabedit<CR>", desc = "Open New Tab", icon = require("config.theme").icons.dashboard },
      { "<leader>tt", require("fzf-lua").tmux_buffers, desc = "List Tmux Paste Buffer", mode = "n" },
      { "<leader>q", group = "Exit", icon = require("config.theme").icons.exit2 },
      { "<leader>qq", "<cmd>quitall<CR>", desc = "Quit All" },
    })
  end,
}
