local theme = require("config.theme")

vim.opt.signcolumn = "yes"

return {
  {

    "neovim/nvim-lspconfig",
    dependencies = {

      -- Auto Install LSP by Mason
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- status update for LSP
      { "j-hui/fidget.nvim", opts = {} },

      {
        "Wansmer/symbol-usage.nvim",
        event = "LspAttach",
        lazy = true,
        config = symbol_usage_configure,
      },
      {
        "icholy/lsplinks.nvim",
        event = "LspAttach",
        lazy = true,
        config = function()
          require("lsplinks").setup()
        end,
      },
    },

    opts = {
      inlay_hints = { enabled = true },
      --- @type vim.diagnostic.config
      diagnostics = {
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        underlinder = true,
        underline = { severity = vim.diagnostic.severity.ERROR },
        update_in_insert = true,
        float = {
          spacing = 4,
          border = "rounded",
          focusable = true,
          source = "if_many",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = theme.diagnostics_icons.Error,
            [vim.diagnostic.severity.WARN] = theme.diagnostics_icons.Warn,
            [vim.diagnostic.severity.HINT] = theme.diagnostics_icons.Hint,
            [vim.diagnostic.severity.INFO] = theme.diagnostics_icons.Info,
          },
        },
      },
      codelens = { enabled = true },
    },

    config = function()
      vim.g.inlay_hints = true

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local keys = {
            {
              "gF",
              "<cmd>lua vim.lsp.buf.format({ async = true })<cr>",
              mode = { "n", "x" },
              icon = theme.icons.magic,
              desc = "Format File",
            },
            {
              "gA",
              "<cmd>lua vim.lsp.codelens.run()<cr>",
              desc = "Code Lens",
              icon = theme.icons.codelens,
              mode = { "n", "x" },
            },
            {
              "gL",
              "<cmd>lua vim.lsp.codelens.refresh()<cr>",
              desc = "Refresh Lenses",
              icon = theme.icons.codelens,
              mode = { "n", "x" },
            },
            {
              "ga",
              require("fzf-lua").lsp_code_actions,
              desc = "Code Actions",
              icon = theme.icons.codelens,
              mode = { "n", "x" },
            },
            {
              "<c-k>",
              "<cmd>lua vim.lsp.buf.signature_help()<cr>",
              desc = "Signature Help",
              icon = theme.icons.Function,
              mode = "i",
            },
            {
              "gz",
              "<cmd>lua vim.lsp.buf.signature_help()<cr>",
              desc = "Signature Help",
              icon = theme.icons.Function,
            },
            {
              "gd",
              function()
                Snacks.picker.lsp_definitions()
              end,
              desc = "Goto Definition",
              icon = theme.icons.go,
            },
            {
              "gD",
              function()
                Snacks.picker.lsp_declarations()
              end,
              desc = "Goto Declaration",
              icon = theme.icons.go,
            },
            {
              "gt",
              function()
                Snacks.picker.lsp_type_definitions()
              end,
              desc = "Goto Type Definition",
              icon = theme.icons.go,
            },
            {
              "go",
              function()
                Snacks.picker.lsp_symbols()
              end,
              desc = "Document Symbols",
              icon = theme.icons.docs,
            },
            {
              "gO",
              function()
                Snacks.picker.lsp_workspace_symbols()
              end,
              desc = "Workspace Symbols",
              icon = theme.icons.docs,
            },
            {
              "gr",
              function()
                Snacks.picker.lsp_references()
              end,
              desc = "Goto References",
              icon = theme.icons.go,
            },
            {
              "gi",
              function()
                Snacks.picker.lsp_implementations()
              end,
              desc = "Goto Implementations",
              icon = theme.icons.go,
            },
            {
              "gl",
              "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', focusable = true })<cr>",
              desc = "Line Diagnostics",
              icon = theme.diagnostics_icons.Hint,
            },
            {
              "gR",
              "<cmd>lua vim.lsp.buf.rename()<cr>",
              desc = "Rename Symbol",
              icon = theme.icons.rename,
            },
            {
              "gN",
              function()
                diagnostics("next", vim.diagnostic.severity.ERROR)
              end,
              desc = "Next ERROR",
              icon = theme.diagnostics_icons.Error,
            },
            {
              "gx",
              require("lsplinks").gx,
              desc = "Open Link",
              icon = "theme.icons.world",
            },
            {
              "gP",
              function()
                diagnostics("prev", vim.diagnostic.severity.ERROR)
              end,
              desc = "Previous ERROR",
              icon = theme.diagnostics_icons.Error,
            },
            {
              "gn",
              function()
                diagnostics("next", vim.diagnostic.severity.WARN)
              end,
              desc = "Next WARN",
              icon = theme.diagnostics_icons.Warn,
            },
            {
              "gp",
              function()
                diagnostics("prev", vim.diagnostic.severity.WARN)
              end,
              desc = "Previous WARN",
              icon = theme.diagnostics_icons.Warn,
            },
            {
              "gT",
              function()
                diagnostics("next", vim.diagnostic.severity.HINT)
              end,
              desc = "Next HINT",
              icon = theme.diagnostics_icons.Hint,
            },
            {
              "ge",
              require("fzf-lua").lsp_document_diagnostics,
              desc = "Local Diagnostics",
              icon = theme.diagnostics_icons.Hint,
            },
            {
              "gE",
              require("fzf-lua").lsp_workspace_diagnostics,
              desc = "Workspace Diagnostics",
              icon = theme.diagnostics_icons.Hint,
            },
            {
              "gw",
              function(buf, value)
                local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
                if type(ih) == "function" then
                  ih(buf, value)
                elseif type(ih) == "table" and ih.enable then
                  if value == nil then
                    value = not ih.is_enabled(buf)
                  end
                  ih.enable(value)
                end
              end,
              desc = "Toggle Inlay Hints",
              icon = theme.icons.inlay,
            },
            {
              "gW",
              function()
                local save_cursor = vim.fn.getpos(".")
                vim.cmd([[%s/\s\+$//e]])
                vim.fn.setpos(".", save_cursor)
              end,
              desc = "Trim Whitespaces",
              icon = theme.icons.project,
            },
          }
          require("which-key").add(keys)
        end,
      })
    end,
  },
  -- hightlight TODO/NOTE tags , and showing colors on the code of color hex like #E95678
  {
    "echasnovski/mini.hipatterns",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },
}
