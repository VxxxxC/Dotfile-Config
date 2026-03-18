return {
  {
    "saghen/blink.cmp",
    enabled = true,
    dependencies = { "rafamadriz/friendly-snippets" },

    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      ---@module 'blink.cmp'
      ---@type blink.cmp.config.keymap
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_and_accept" },
        ["<S-Tab>"] = { "hide" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      },

      appearance = {
        nerd_font_variant = "Nerd Font",
      },

      completion = {
        keyword = {
          range = "prefix",
        },
        ghost_text = { enabled = true },
        documentation = { window = { border = "single" }, auto_show = true },
        trigger = {
          show_in_snippet = true,
          show_on_keyword = true,
          show_on_trigger_character = true,
          show_on_blocked_trigger_characters = { " ", "\n", "\t" },
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
        menu = {
          border = "single",
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = { { "kind" }, { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
            treesitter = { "lsp" },
          },
        },
      },
      signature = { window = { border = "single" } },

      sources = {
        providers = {
          lsp = {
            name = "lsp",
            enabled = true,
            module = "blink.cmp.sources.lsp",
          },
          snippets = {
            name = "snippets",
            enabled = true,
            module = "blink.cmp.sources.snippets",
          },
        },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
