return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("plugins.colorscheme").setup({
				flavor = "mocha",
			})
		end,
	},
	{
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
},
{ "rose-pine/neovim", name = "rose-pine" },
{ "rebelot/kanagawa.nvim" },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme ="rose-pine"
		},
	},
}
