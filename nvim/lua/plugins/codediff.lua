return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  opts = {
    explorer = {
      view_mode = "tree",
      width = 50,
      auto_open_on_cursor = true, -- open the file under the cursor as you move
      line_stats = {
        enabled = true, -- show +/- line stats
      },
    },
    diff = {
      compact = true, -- only show changes
      compact_context_lines = 8,
      compact_sync_folds = true, -- sync folds across panes
    },
  },

  init = function()
    -- Close the codediff session in the current tab if there is one, otherwise open :CodeDiff.
    -- Uses the same close function as codediff's own `q` keymap.
    local function toggle_diff_view()
      local lifecycle = package.loaded["codediff.ui.lifecycle"]
      if lifecycle and lifecycle.get_session(vim.api.nvim_get_current_tabpage()) then
        lifecycle.close()
      else
        vim.cmd("CodeDiff")
      end
    end

    local wk = require("which-key")
    wk.add({
      { "<leader>gv", toggle_diff_view, desc = "Toggle diff view (CodeDiff)" },
      { "<leader>gh", "<cmd>CodeDiff history %<cr>", desc = "Current file history (CodeDiff)" },
      { "<leader>gH", "<cmd>CodeDiff history<cr>", desc = "Repo history (CodeDiff)" },
    })
  end,
}
