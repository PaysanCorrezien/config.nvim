return {
	name = "Run PowerShell Script",
	builder = function()
		local file = vim.fn.expand("%:p")
		return {
			cmd = { "pwsh" },
			args = { "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", file },
			name = "Run PS1",
			cwd = vim.fn.expand("%:p:h"),
			components = { "output_buffer", "default" },
		}
	end,
	condition = {
		filetype = { "ps1" },
	},
	desc = "Run the current .ps1 script ",
}
