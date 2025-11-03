return {
  {
    "creativenull/efmls-configs-nvim",
    version = "v1.x.x",

    init = function()
      local solhint = require("efmls-configs.linters.solhint")
      local prettier_d = require("efmls-configs.formatters.prettier_d")
      local languages = {
        solidity = { solhint, prettier_d },
      }

      local efmls_configs = {
        filetypes = vim.tbl_keys(languages),
        init_options = {
          documentFormatting = true,
          documentRangeFormatting = true,
          hover = true,
          documentSymbol = true,
          codeAction = true,
        },
        settings = {
          rootMarkers = { ".git/" },
          languages = languages,
        },
      }

      vim.lsp.config(
        "efm",
        vim.tbl_extend("force", efmls_configs, {
          cmd = { "efm-langserver" },
        })
      )
    end,
  },
}
