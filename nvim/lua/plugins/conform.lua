-- INFO: Code Formatting.

--- Use a language-SDK formatter only when it is installed (SDKs are installed
--- manually per project), otherwise fall back to the LSP without warning on every save.
---@param formatter string
local function if_available(formatter)
  return function(bufnr)
    local available = require("conform").get_formatter_info(formatter, bufnr).available
    return { available and formatter or nil, lsp_format = "fallback" }
  end
end

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      notify_on_error = true,
      notify_no_formatters = true,
      formatters_by_ft = {
        python = if_available("ruff_format"),
        javascript = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        javascriptreact = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        json = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        jsonc = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        less = { "prettierd" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        -- rustaceanvim's LSP client is named "rust-analyzer" (not lspconfig's "rust_analyzer")
        rust = { name = "rust-analyzer", timeout_ms = 500, lsp_format = "prefer" },
        scss = { "prettierd" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        typescript = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        typescriptreact = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        svelte = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        yaml = { "yamlfmt" },
        toml = { "taplo" },
        solidity = if_available("forge_fmt"),
        java = if_available("google-java-format"),
        kotlin = if_available("ktfmt"),

        -- For filetypes without a formatter:
        ["_"] = { "trim_whitespace", "trim_newlines" },
      },
      format_on_save = function()
        -- Don't format when minifiles is open, since that triggers the "confirm without
        -- synchronization" message.
        if vim.g.minifiles_active then
          return nil
        end

        -- Stop if we disabled auto-formatting.
        if not vim.g.autoformat then
          return nil
        end

        return {
          lsp_format = "fallback",
          timeout_ms = 500,
        }
      end,
      formatters = {
        -- Require a prettier configuration file to format.
        prettier = { require_cwd = true },
        taplo = { command = "taplo", args = { "format" } },
      },
    },

    init = function()
      -- Use conform for gq.
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      -- Start auto-formatting by default (and disable with my ToggleFormat command).
      vim.g.autoformat = true
    end,
  },
}
