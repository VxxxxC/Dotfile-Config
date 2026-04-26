return {
  {
    "carlos-algms/agentic.nvim",

    --- @type agentic.PartialUserConfig
    opts = {
      -- Any ACP-compatible provider works. Built-in: "claude-agent-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp" | "copilot-acp" | "auggie-acp" | "mistral-vibe-acp" | "cline-acp" | "goose-acp"
      provider = "copilot-acp", -- setting the name here is all you need to get started
    },
    init = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>c", group = "Copilot", icon = require("config.theme").icons.copilot },
        {
          "<leader>cT",
          function()
            require("agentic").toggle()
          end,
          mode = { "n", "v", "i" },
          desc = "Toggle Agentic Chat",
        },
        {
          "<leader>cR",
          function()
            require("agentic").restore_session()
          end,
          desc = "Agentic Restore session",
          silent = true,
          mode = { "n", "v", "i" },
        },
        {
          "<leader>cd",
          function()
            require("agentic").add_current_line_diagnostics()
          end,
          desc = "Add current line diagnostic to Agentic",
          mode = { "n" },
        },
        {
          "<leader>cD",
          function()
            require("agentic").add_buffer_diagnostics()
          end,
          desc = "Add all buffer diagnostics to Agentic",
          mode = { "n" },
        },
      })
    end,
  },
}
