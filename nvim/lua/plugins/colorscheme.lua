return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      -- Set my colorscheme.
      vim.g.colors_name = "solarized-osaka"
      vim.cmd("colorscheme solarized-osaka")
    end,
  },
}
