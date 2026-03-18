return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
      view_options = {
        show_hidden = true,
      },
    })
  end,
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,

  init = function()
    local wk = require("which-key")
    wk.add({
      {
        "<leader>e",
        "<cmd>Oil --float<CR>",
        desc = "open floating Oil file explorer",
        icon = require("config.theme").icons.window,
        mode = "n",
      },
    })
  end,
}
