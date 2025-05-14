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

  keys = {
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
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },
    {
      ";;",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume last picker searching",
    },
  },
}
