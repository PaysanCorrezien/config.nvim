return {
	-- {
	-- 	"mini.comment",
	-- 	enabled = false,
	-- },
	{
		"numToStr/Comment.nvim",
		lazy = false,
		-- event = { "BufReadPost", "BufNewFile" },
		config = true,
		keys = {
			-- { "/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment" },
		},
	},
}
