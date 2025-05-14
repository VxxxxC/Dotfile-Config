-- for better comment on jsx/tsx
return {
  {
    "numToStr/Comment.nvim",

    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          ---Line-comment toggle keymap
          line = "gc",
          ---Block-comment toggle keymap
          block = "gb",
        },
      })
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",

    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
    end,
  },
}
