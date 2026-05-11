return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      "theHamsta/nvim-dap-virtual-text",
    },

    config = function()
      local dap, dapui = require("dap"), require("dapui")
      -- INFO: Set auto open/close dap-ui when dap is triggered
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- INFO: Manual set Rust debugger adapter
      dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb",
        name = "lldb",
      }
    end,

    init = function()
      local keys = {
        { "<leader>d", group = "Dap", icon = require("config.theme").icons.debug },
        {
          "<leader>dB",
          function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Breakpoint Condition",
        },
        {
          "<leader>db",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Toggle Breakpoint",
        },
        {
          "<leader>dc",
          function()
            require("dap").continue()
          end,
          desc = "Run/Continue",
        },
        {
          "<leader>da",
          function()
            require("dap").continue({ before = get_args })
          end,
          desc = "Run with Args",
        },
        {
          "<leader>dC",
          function()
            require("dap").run_to_cursor()
          end,
          desc = "Run to Cursor",
        },
        {
          "<leader>dg",
          function()
            require("dap").goto_()
          end,
          desc = "Go to Line (No Execute)",
        },
        {
          "<leader>di",
          function()
            require("dap").step_into()
          end,
          desc = "Step Into",
        },
        {
          "<leader>dj",
          function()
            require("dap").down()
          end,
          desc = "Down",
        },
        {
          "<leader>dk",
          function()
            require("dap").up()
          end,
          desc = "Up",
        },
        {
          "<leader>dl",
          function()
            require("dap").run_last()
          end,
          desc = "Run Last",
        },
        {
          "<leader>do",
          function()
            require("dap").step_out()
          end,
          desc = "Step Out",
        },
        {
          "<leader>dO",
          function()
            require("dap").step_over()
          end,
          desc = "Step Over",
        },
        {
          "<leader>dP",
          function()
            require("dap").pause()
          end,
          desc = "Pause",
        },
        {
          "<leader>dr",
          function()
            require("dap").repl.toggle()
          end,
          desc = "Toggle REPL",
        },
        {
          "<leader>ds",
          function()
            require("dap").session()
          end,
          desc = "Session",
        },
        {
          "<leader>dt",
          function()
            require("dap").terminate()
          end,
          desc = "Terminate",
        },
        {
          "<leader>dw",
          function()
            require("dap.ui.widgets").hover()
          end,
          desc = "Widgets",
        },
      }
      require("which-key").add(keys)
    end,
    -- stylua: ignore
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {},
    init = function()
      local key = {
        {
          "<leader>dT",
          function()
            require("dapui").toggle()
          end,
          desc = "Toggle Dap UI",
        },
      }
      require("which-key").add(key)
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {
      enabled = true, -- enable this plugin (the default)
      enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    },
  },
}
