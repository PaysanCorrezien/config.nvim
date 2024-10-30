return {
	{
		"ecthelionvi/NeoComposer.nvim",
		dependencies = { "kkharji/sqlite.lua" },
		lazy = false,
		opts = {},
		config = function()
			require("NeoComposer").setup()
		end,
		keys = {
			{ "<leader>xm", "<cmd>:Telescope macros<cr>", desc = "Neo Macros" },
			{ "<leader>xE", ":EditMacros<cr>", desc = "Edit Macros" },
		},
	},
}
