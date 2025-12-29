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
        find = "sF",
        find_left = "fL",
        highlight = "sH",
        replace = "sr",

        -- Add this only if you don't want to use extended mappings
        suffix_last = "",
        suffix_next = "",
      },
      search_method = "cover_or_next",
    })
  end,
}
