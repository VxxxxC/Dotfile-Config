local wk_status, wk = pcall(require, "which-key")
if not wk_status then
  return
end

local theme_status, theme = pcall(require, "config.theme")

return {
  "toppair/peek.nvim",
  event = { "VeryLazy" },
  build = "deno task --quiet build:fast",
  config = function()
    require("peek").setup({
      syntax = true,
      theme = "dark",
      update_on_change = true,
      app = "webview",
      filetype = { "markdown" },
    })
    vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
    vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})

    local keys = {
      {
        "<leader>mo",
        function()
          local open = require("peek").open
          open()
        end,
        desc = "Markdown PreviewOpen",
      },
      {
        "<leader>mc",
        function()
          local close = require("peek").close
          close()
        end,
        desc = "Markdown Preview Close",
      },
    }

    wk.add({
      -- Markdown Preview
      { "<leader>m", group = "Markdown Preview", icon = theme.icons.window },
      keys,
    })
  end,
}
