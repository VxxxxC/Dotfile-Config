-- INFO: Code Formatting.
return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      notify_on_error = true,
      notify_no_formatters = true,
      formatters_by_ft = {
        javascript = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        javascriptreact = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        json = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        jsonc = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        less = { "prettierd" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        rust = { name = "rust_analyzer", timeout_ms = 500, lsp_format = "prefer" },
        scss = { "prettierd" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        typescript = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        typescriptreact = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        svelte = { "prettierd", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        yaml = { "yamlfmt" },
        toml = { "taplo" },
        solidity = { "forge_fmt" },

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
          timtout_ms = 500,
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
