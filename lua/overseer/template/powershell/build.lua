return {
	name = "Run Build Script",
	builder = function()
		local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
		local build_script_path = git_root and git_root .. "/build.ps1" or ""
		if vim.fn.filereadable(build_script_path) == 1 then
			return {
				cmd = { "pwsh" },
				args = { "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", build_script_path },
				name = "Run build.ps1",
				cwd = git_root,
				components = { "output_buffer", "default" },
			}
		else
			return nil -- No task if conditions aren't met
		end
	end,
	condition = {
		callback = function()
			-- Simplify by combining git repo check, build.ps1 existence, and filetype check
			local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree"):find("true")
			local git_root = is_git_repo and vim.fn.systemlist("git rev-parse --show-toplevel")[1] or ""
			local build_script_path = git_root .. "/build.ps1"
			local is_ps1_filetype = vim.bo.filetype == "ps1"

			return is_git_repo and vim.fn.filereadable(build_script_path) == 1 and is_ps1_filetype
		end,
	},
	desc = "Find and run build.ps1 in the current Git repository if editing a PS1 file",
	tags = { "build" },
}
