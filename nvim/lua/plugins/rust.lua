return {
  {
    "mrcjkb/rustaceanvim",
    -- rustaceanvim lazy-loads itself via ftplugin; don't let lazy.nvim lazy-load it.
    lazy = false,
    version = "^9",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    -- vim.g.rustaceanvim must be set before the rust ftplugin runs, so use `init`.
    init = function()
      -- Use lldb-dap from `brew install llvm` (same as dap.adapters.lldb in dap.lua).
      -- If it isn't found, leave `adapter` unset so rustaceanvim auto-detects
      -- (codelldb on PATH / Mason codelldb / lldb-dap).
      local brew_lldb_dap = "/opt/homebrew/opt/llvm/bin/lldb-dap"
      local lldb_dap = vim.fn.executable(brew_lldb_dap) == 1 and brew_lldb_dap or vim.fn.exepath("lldb-dap")

      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        -- NOTE: mason-lspconfig must not enable rust_analyzer (see mason.lua)
        server = {},
        -- DAP configuration
        dap = {
          adapter = lldb_dap ~= "" and { type = "executable", command = lldb_dap, name = "lldb" } or nil,
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    ft = "toml",
    lazy = true,
  },
}
