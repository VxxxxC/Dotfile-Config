return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    indent = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true, hidden = true, ignored = true },
    quickfile = { enabled = true },
  },

  init = function()
    local keys = {
      {
        ";r",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        ";R",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      {
        ";f",
        function()
          Snacks.picker.files({ hidden = true, ignored = true })
        end,
        desc = "Find Files",
      },
      {
        ";;",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume last picker searching",
      },
      {
        "<leader>g",
        group = "Git",
        icon = require("config.theme").icons.git,
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
        mode = { "n", "v" },
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>b",
        group = "Buffer",
        icon = require("config.theme").icons.buffers,
      },
      {
        "<leader>bf",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Find Buffer",
      },
      {
        "<leader>br",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep Buffer",
      },
    }
    require("which-key").add(keys)
  end,
}
