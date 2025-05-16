return {
  --[[ {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opt = {
      transparent = true,
    },
    init = function()
      -- Set my colorscheme.
      vim.g.colors_name = "solarized-osaka"
    end,
  }, ]]
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    init = function()
      vim.g.colors_name = "nightfox"
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfox",
    },
  },
}
