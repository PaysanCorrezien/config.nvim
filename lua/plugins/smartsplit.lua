return {
	--FIXME: not realy working
	{
		"mrjones2014/smart-splits.nvim",
		config = function()
			require("smart-splits").setup({
				-- Ignored filetypes (only while resizing)
				ignored_filetypes = {
					"nofile",
					"quickfix",
					"prompt",
				},
				-- Multiplexer configuration
				mux = {
					type = "wezterm",
				},
				-- Default direction
				direction = "right",
				-- Utility functions
				split = function() end, -- Placeholder function, replace with actual implementation
				wrap = function() end, -- Placeholder function, replace with actual implementation
				-- Behavior at edge
				at_edge = "wrap",
				resize_mode = {
					-- key to exit persistent resize mode
					quit_key = "<ESC>",
					-- keys to use for moving in resize mode
					-- in order of left, down, up' right
					resize_keys = { "h", "j", "k", "l" },
					-- set to true to silence the notifications
					-- when entering/exiting persistent resize mode
					silent = false,
					-- must be functions, they will be executed when
					-- entering or exiting the resize mode
					hooks = {
						on_enter = nil,
						on_leave = nil,
					},
				},
				-- igno
			})
		end,
	},
}
