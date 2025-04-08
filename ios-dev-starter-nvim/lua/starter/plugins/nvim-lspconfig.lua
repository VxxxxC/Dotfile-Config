return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      {
        "Wansmer/symbol-usage.nvim",
        event = "LspAttach",
        lazy = true,
        config = symbol_usage_configure,
      },
      {
        "aznhe21/actions-preview.nvim",
        event = "LspAttach",
        lazy = true,
        config = function()
          require("actions-preview").setup({
            telescope = {
              sorting_strategy = "descending",
              layout_strategy = "bottom_pane",
            },
          })
        end,
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
    --- @class PluginLspOpts
    opts = {
      --- @type vim.diagnostic.config
      diagnostics = {
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        underlinder = true,
        update_in_insert = true,
        float = {
          spacing = 4,
          border = "rounded",
          focusable = true,
          source = "if_many",
        },
        severity_sort = true,
      },
      codelens = { enabled = true },
    },
    init = function()
      local keys = {
        {
          "gF",
          "<cmd>lua vim.lsp.buf.format({ async = true })<cr>",
          mode = { "n", "x" },
          desc = "Format File",
        },
        {
          "gA",
          "<cmd>lua vim.lsp.codelens.run()<cr>",
          desc = "Code Lens",
          mode = { "n", "x" },
        },
        {
          "gL",
          "<cmd>lua vim.lsp.codelens.refresh()<cr>",
          desc = "Refresh Lenses",
          mode = { "n", "x" },
        },
        {
          "ga",
          "<cmd>lua require('actions-preview').code_actions()<cr>",
          desc = "Code Actions",
          mode = { "n", "x" },
        },
        {
          "<c-k>",
          "<cmd>lua vim.lsp.buf.signature_help()<cr>",
          desc = "Signature Help",
          mode = "i",
        },
        {
          "gz",
          "<cmd>lua vim.lsp.buf.signature_help()<cr>",
          desc = "Signature Help",
        },
        {
          "gD",
          "<cmd>Telescope lsp_definitions<cr>",
          desc = "Goto Definition",
        },
        {
          "gt",
          "<cmd>Telescope lsp_type_definitions<cr>",
          desc = "Goto Type Definition",
        },
        {
          "gd",
          "<cmd>lua vim.lsp.buf.declaration()<cr>",
          desc = "Goto Declaration",
        },
        {
          "gO",
          "<cmd>Telescope lsp_document_symbols<cr>",
          desc = "Document Symbols",
        },
        {
          "gr",
          "<cmd>Telescope lsp_references jump_type=never<cr>",
          desc = "Goto References",
        },
        {
          "gi",
          "<cmd>Telescope lsp_implementations jump_type=never reuse_win=true<cr>",
          desc = "Goto Implementations",
        },
        {
          "gl",
          "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', focusable = true })<cr>",
          desc = "Line Diagnostics",
        },
        {
          "gR",
          "<cmd>lua vim.lsp.buf.rename()<cr>",
          desc = "Rename Symbol",
        },
        {
          "gx",
          require("lsplinks").gx,
          desc = "Open Link",
        },
        {
          "gN",
          function()
            diagnostics("next", vim.diagnostic.severity.ERROR)
          end,
          desc = "Next ERROR",
        },
        {
          "gP",
          function()
            diagnostics("prev", vim.diagnostic.severity.ERROR)
          end,
          desc = "Previous ERROR",
        },
        {
          "gn",
          function()
            diagnostics("next", vim.diagnostic.severity.WARN)
          end,
          desc = "Next WARN",
        },
        {
          "gp",
          function()
            diagnostics("prev", vim.diagnostic.severity.WARN)
          end,
          desc = "Previous WARN",
        },
        {
          "gT",
          function()
            diagnostics("next", vim.diagnostic.severity.HINT)
          end,
          desc = "Next HINT",
        },
        {
          "ge",
          "<cmd>Telescope diagnostics<cr>",
          desc = "Diagnostics",
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
        },
        {
          "gW",
          function()
            local save_cursor = vim.fn.getpos(".")
            vim.cmd([[%s/\s\+$//e]])
            vim.fn.setpos(".", save_cursor)
          end,
          desc = "Trim Whitespaces",
        },
        {
          "gb",
          require("dap").toggle_breakpoint,
          desc = "Toggle Breakpoint",
        },
      }
      require("which-key").add(keys)
    end,
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      local opts = { noremap = true, silent = true }
      local on_attach = function(_, bufnr)
        opts.buffer = bufnr

        opts.desc = "Show line diagnostics"
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Show documentation for what is under cursor"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Show LSP definition"
        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions trim_text=true<cr>", opts)
      end

      lspconfig["sourcekit"].setup({
        cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
        capabilities = capabilities,
        on_attach = on_attach,
        on_init = function(client)
          -- HACK: to fix some issues with LSP
          -- more details: https://github.com/neovim/neovim/issues/19237#issuecomment-2237037154
          client.offset_encoding = "utf-8"
        end,
      })

      -- nice icons
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end,
  },
}
