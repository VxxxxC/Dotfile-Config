return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = "copilotlsp-nvim/copilot-lsp",
    cmd = "Copilot",
    event = "VeryLazy",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
          },
          layout = {
            position = "right", -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<ESC>",
          },
        },
        filetypes = {
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 16.x
        server_opts_overrides = {},
      })
    end,

    init = function()
      -- set keymap for copilot.lua
      vim.keymap.set("n", "<C-i>", function()
        if require("copilot.panel").is_open() == true then
          require("copilot.panel").accept()
        else
          return
        end
      end, { desc = "Open Copilot Panel" }, opts)

      vim.keymap.set("i", "<C-i>", "<cmd>Copilot suggestion accept<CR>", { desc = "Accept Copilot Suggestion" }, opts)
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      model = "gpt-4.1", -- AI model to use
      temperature = 0.5, -- Lower = focused, higher = creative
      window = {
        layout = "float", -- 'vertical', 'horizontal', 'float'
        width = 80, -- fix width
        height = 20, -- fix height
        border = "rounded", -- 'single', 'double', 'rounded', 'solid', 'shadow'
        title = "🤖 AI Assistant",
        zindex = 100, -- Ensure window stays on top
      },

      headers = {
        user = "👤 You",
        assistant = "🤖 Copilot",
        tool = "🔧 Tool",
      },

      separator = "━━",
      auto_fold = true, -- Automatically folds non-assistant messages
      auto_insert_mode = true, -- Enter insert mode when opening
    },

    init = function()
      vim.api.nvim_set_hl(0, "CopilotChatHeader", { fg = "#7C3AED", bold = true })
      vim.api.nvim_set_hl(0, "CopilotChatSeparator", { fg = "#374151" })

      ---@warn:
      --- Some plugins (e.g. copilot.vim) may also map common keys like <Tab> in insert mode.
      --- To avoid conflicts, disable Copilot's default <Tab> mapping with:
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })

      local wk = require("which-key")
      wk.add({
        { "<leader>c", group = "Copilot", icon = require("config.theme").icons.copilot },
        { "<leader>cc", "<cmd>CopilotChatToggle<CR>", desc = "Open Copilot Chat Panel", mode = "n" },
        { "<leader>cp", "<cmd>CopilotChatPrompts<CR>", desc = "Open Copilot Chat Panel", mode = "v" },
        { "<leader>cm", "<cmd>CopilotChatModel<CR>", desc = "Select Copilot Chat Model", mode = "n" },
        { "<leader>ct", "<cmd>CopilotChatTool<CR>", desc = "Select Copilot Chat Tool", mode = "n" },
      })
    end,
  },
}
