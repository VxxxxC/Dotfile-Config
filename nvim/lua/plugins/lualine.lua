return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local LazyVim = require("lazyvim.util")
      require("lualine").setup({
        sections = {
          lualine_c = {

            LazyVim.lualine.pretty_path({
              length = 0,
              relative = "cwd",
              modified_hl = "MatchParen",
              directory_hl = "",
              filename_hl = "Bold",
              modified_sign = "",
              readonly_icon = " 󰌾 ",
            }),
          },
        },
      })
    end,
  },
}
