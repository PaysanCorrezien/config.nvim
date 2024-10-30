return {
	name = "Rust: Run Clean and Build Task",
	builder = function()
		local winLogs = vim.fn.expand("C:\\Users\\dylan\\AppData\\roaming\\WinLogs\\app.log")
		local cleanup_command = "Remove-Item -Path '" .. winLogs .. "' -Force"
		local build_command = "cargo build"
		return {
			cmd = "pwsh",
			args = { "-NoProfile", "-Command", cleanup_command .. "; " .. build_command },
			name = "Rust: Clean and Build",
			cwd = vim.fn.expand("%:p:h"), -- Task working in the present active document location
			components = { "on_output_quickfix", "default" },
		}
	end,
	condition = {
		filetype = { "rust" },
	},
	desc = "Clean WinLogs and build the current Rust project",
	tags = { "build", "rust" },
}
