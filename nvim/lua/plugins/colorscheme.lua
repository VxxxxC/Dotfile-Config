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
      vim.cmd("colorscheme solarized-osaka")
    end,
  }, ]]
  {
    "oxfist/night-owl.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("night-owl").setup({
        bold = true,
        italics = true,
        underline = true,
        undercurl = true,
        transparent_background = true,
      })
      vim.g.colors_name = "night-owl"
      vim.cmd("colorscheme night-owl")
    end,
  },
}
