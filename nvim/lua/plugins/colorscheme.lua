return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opt = {},
		init = function()
			-- Set my colorscheme.
			vim.g.colors_name = "solarized-osaka"
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "solarized-osaka",
		},
	},
}
