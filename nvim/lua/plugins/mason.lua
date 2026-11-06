return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      local ensure_installed = {
        "bashls",
        "lua_ls",
        "ts_ls",
        "eslint",
        "tailwindcss",
        "cssls",
        "html",
        "yamlls",
        "rust_analyzer",
        "solidity_ls",
      }

      -- gopls is built with `go install`, so only install it when Go is available
      -- (language SDKs are installed manually, not by the Makefile).
      if vim.fn.executable("go") == 1 then
        table.insert(ensure_installed, "gopls")
      end

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        -- rust-analyzer is started by rustaceanvim; enabling it here too would
        -- attach a second, conflicting client (see :h rustaceanvim.mason).
        automatic_enable = {
          exclude = { "rust_analyzer" },
        },
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        "bash",
        "js",
        "codelldb",
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },
}
