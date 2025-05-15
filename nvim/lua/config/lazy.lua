-- Install LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- require("statusline")
require("settings")
require("winbar")

require("lazy").setup({
  ui = { border = "rounded" },
  spec = {
    -- add LazyVim and import its plugins
    -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    -- { import = "lazyvim.plugins.extras.linting.eslint" },
    -- { import = "lazyvim.plugins.extras.formatting.prettier" },
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "plugins" },
    { "wakatime/vim-wakatime", lazy = false },
  },
  defaults = {
    autocmds = true,
    keymaps = true,
    version = false, -- always use the latest git commit
  },

  install = {
    missing = false,
  },

  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = true, -- notify on update
  }, -- automatically check for plugin updates

  rocks = {
    enabled = false,
  },

  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- to prevent showing the un-ordered plugins import warning when starting nvim
vim.g.lazyvim_check_order = false

-- enable showkeys when nvim start
vim.cmd("ShowkeysToggle")
