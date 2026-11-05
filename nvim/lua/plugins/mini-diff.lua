return {
  "nvim-mini/mini.diff",
  event = "VeryLazy",
  opts = {
    mappings = {
      goto_prev = "[c",
      goto_next = "]c",
    },
  },

  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay()
        end,
        desc = "Toggle diff overlay (mini.diff)",
      },
    })
  end,
}
