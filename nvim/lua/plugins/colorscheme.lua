return {
  -- {
  --   "craftzdog/solarized-osaka.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   init = function()
  --     -- Set my colorscheme.
  --     vim.g.colors_name = "solarized-osaka"
  --     vim.cmd("colorscheme solarized-osaka")
  --   end,
  -- },
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,

    config = function()
      require("bamboo").setup({
        style = "multiplex",
        toggle_style_list = { "multiplex" },
        transparent = true,
        term_colors = true,
        dim_inactive = true,

        code_style = {
          comments = "italic",
          keywords = "bold",
        },

        lualine = {
          transparent = true,
        },
      })
      require("bamboo").load()
    end,
    init = function()
      vim.g.colors_name = "bamboo"
      vim.cmd("colorscheme bamboo")
    end,
  },
}
