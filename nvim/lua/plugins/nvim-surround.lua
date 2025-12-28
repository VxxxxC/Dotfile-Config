return {
  "nvim-mini/mini.surround",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("mini.surround").setup({
      -- Configuration here, or leave empty to use defaults
      mappings = {
        add = "ss",
        delete = "sd",
        find = "sf",
        find_left = "fl",
        highlight = "sh",
        replace = "sr",

        -- Add this only if you don't want to use extended mappings
        suffix_last = "",
        suffix_next = "",
      },
      search_method = "cover_or_next",
    })
  end,
}
