-- Highlight, edit, and navigate code.
-- NOTE: nvim-treesitter `main` branch (Neovim >= 0.12). The old `nvim-treesitter.configs`
-- module no longer exists: highlight / indent are enabled per buffer via a FileType autocmd,
-- and incremental selection uses Neovim's built-in `vim.treesitter.select()`.
-- Requires `tree-sitter` CLI and a C compiler to build parsers.

local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "fish",
  "gitcommit",
  "go",
  "graphql",
  "html",
  "java",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "rasi",
  "regex",
  "rust",
  "scss",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "solidity",
}

-- Treesitter unindents Yaml lists for some reason.
local indent_disabled = { yaml = true }

---@param buf integer
---@param lang string
local function attach(buf, lang)
  if not pcall(vim.treesitter.start, buf, lang) then
    return
  end

  if not indent_disabled[lang] then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end

  -- Incremental selection (built into Neovim 0.12)
  local function map(mode, lhs, target, desc)
    vim.keymap.set(mode, lhs, function()
      vim.treesitter.select(target, vim.v.count1)
    end, { buffer = buf, desc = desc })
  end
  map("n", "<Enter>", "parent", "Start treesitter selection")
  map("x", "<Enter>", "parent", "Increment treesitter selection")
  map("x", "<Backspace>", "child", "Decrement treesitter selection")
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          -- Avoid the sticky context from growing a lot.
          max_lines = 3,
          -- Match the context lines to the source code.
          multiline_threshold = 1,
          -- Disable it when the window is too small.
          min_window_height = 20,
        },
      },
    },
    config = function()
      local ts = require("nvim-treesitter")

      -- No-op for parsers that are already installed (runs asynchronously).
      ts.install(ensure_installed)

      local available = {}
      for _, lang in ipairs(ts.get_available()) do
        available[lang] = true
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
        callback = function(args)
          local buf = args.buf
          if vim.bo[buf].buftype ~= "" then
            return
          end

          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then
            return
          end

          if vim.list_contains(ts.get_installed(), lang) or not available[lang] then
            attach(buf, lang)
          else
            -- auto_install: install the missing parser, then attach.
            ts.install(lang):await(function()
              vim.schedule(function()
                if vim.api.nvim_buf_is_valid(buf) then
                  attach(buf, lang)
                end
              end)
            end)
          end
        end,
      })
    end,
  },
}
