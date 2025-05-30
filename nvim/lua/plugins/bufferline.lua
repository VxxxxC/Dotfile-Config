-- Pretty bufferline.
return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "tabs",
        show_close_icon = false,
        show_buffer_close_icons = false,
        truncate_names = false,
        close_command = function(bufnr)
          require("mini.bufremove").delete(bufnr, false)
        end,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = require("config.theme").diagnostics
          local indicator = (diag.error and icons.ERROR .. " " or "") .. (diag.warning and icons.WARN or "")
          return vim.trim(indicator)
        end,
      },
    },
    keys = {
      -- Buffer navigation.
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
  },
}
