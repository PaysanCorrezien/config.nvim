-- TODO:
-- function _G.StartDocusaurusServer()
-- 	local projectDir = "D:\\Users\\dylan\\Documents\\KnowledgeBase"
-- 	local cmd = "cmd /c cd /d " .. projectDir .. " && npm run start"
-- 	vim.fn.jobstart(cmd, { detach = true })
-- end
local function openFile()
	-- Parameters
	-- TODO: make this a global configurable variable
	-- local base_path = "/mnt/c/Users/dylan/Mes documents/Obsidian Vault/Tasks/"
	local base_path = "D:\\notes\\Tasks\\"

	-- Date format
	local date = os.date("*t")
	local year = date.year
	local month = string.format("%02d-%s", date.month, os.date("%B"))
	local day = string.format("%04d-%02d-%02d-%s", year, date.month, date.day, os.date("%A"))

	-- File path
	local file_path = string.format("%s%s/%s/%s.md", base_path, year, month, day)
	local expanded_file_path = vim.fn.expand(file_path)

	-- Create directories if they do not exist
	local dir_path = vim.fn.expand(string.format("%s%s/%s", base_path, year, month))
	if vim.fn.isdirectory(dir_path) ~= 1 then
		vim.fn.mkdir(dir_path, "p")
	end

	-- Open the file
	vim.cmd(string.format("edit %s", file_path))
end

function _G.CreateDailyTask()
	openFile()

	-- Parameters
	local task_heading = "## Taches"
	local task_format = "- [ ] #task"

	-- Find the task heading
	local task_heading_line = -1
	for i = 1, vim.fn.line("$") do
		if vim.fn.getline(i) == task_heading then
			task_heading_line = i
			break
		end
	end

	-- Add a new task below the heading and enter insert mode
	if task_heading_line ~= -1 then
		vim.fn.append(task_heading_line, task_format)
		vim.cmd(string.format("normal! %dG", task_heading_line + 1))
		vim.cmd("startinsert!")
	else
		vim.api.nvim_notify("Task heading not found.", 2, {})
	end
end

-- Creates a note below the "## Notes" heading.
-- If the heading is not found, a notification is sent.
function _G.CreateNote()
	openFile()

	-- Heading to find
	local heading = "## Notes"

	-- Find the heading
	local heading_line = -1
	for i = 1, vim.fn.line("$") do
		if vim.fn.getline(i) == heading then
			heading_line = i
			break
		end
	end

	-- Create a new line below the heading and enter insert mode
	if heading_line ~= -1 then
		vim.fn.append(heading_line, "")
		vim.cmd(string.format("normal! %dG", heading_line + 1))
		vim.cmd("startinsert!")
	else
		vim.api.nvim_notify("Heading not found.", 2, {})
	end
end

function _G.StartDocusaurusServer()
	-- Change directory
	vim.cmd("cd D:\\notes\\")

	-- Create a hidden buffer for the terminal
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.notify("Created buffer: " .. bufnr, vim.log.levels.DEBUG)

	-- Define a callback function to handle job output and exit
	local on_exit = function(job_id, exit_code, event_type)
		vim.schedule(function()
			if exit_code == 0 then
				vim.notify("Node server started successfully!", vim.log.levels.INFO)
			else
				vim.notify("Node server failed to start. See :messages for details.", vim.log.levels.ERROR)
			end
		end)
	end

	-- Configure the hidden buffer options
	vim.api.nvim_buf_call(bufnr, function()
		vim.opt_local.buflisted = false -- Make the buffer unlisted
		vim.opt_local.bufhidden = "hide" -- Hide the buffer when not in use
		vim.notify("Buffer configured: " .. bufnr, vim.log.levels.DEBUG)

		-- Start the Node server in the hidden terminal buffer
		local job_id = vim.fn.termopen("npm run start", {
			on_exit = on_exit,
			on_stderr = function(_, data, _)
				vim.schedule(function()
					-- Capture and log the stderr for errors
					if data then
						for _, line in ipairs(data) do
							if line ~= "" then
								vim.notify(line, vim.log.levels.ERROR)
							end
						end
					end
				end)
			end,
		})
		-- After starting the job:
		vim.g.docusaurus_jobid = job_id
		vim.g.docusaurus_buffer = bufnr

		-- Debug: Notify about job start
		if job_id then
			vim.notify("Job started: " .. job_id .. ", in buffer: " .. bufnr, vim.log.levels.DEBUG)
			vim.notify("Attempting to start Node server...", vim.log.levels.INFO)
		else
			vim.notify("Failed to start Node server job!", vim.log.levels.ERROR)
		end
	end)
end

function _G.StopDocusaurusServer()
	local jobid = vim.g.docusaurus_jobid
	if jobid and vim.fn.jobwait({ jobid }, 0)[1] == -1 then -- Check if job is still running
		local stop_result = vim.fn.jobstop(jobid)
		if stop_result == 1 then
			vim.notify("Docusaurus server stopped successfully.", vim.log.levels.INFO)
		else
			vim.notify("Failed to stop Docusaurus server.", vim.log.levels.ERROR)
		end
	else
		vim.notify("Docusaurus server is not running.", vim.log.levels.INFO)
	end
end

function _G.GetDocusaurusBufferInfo()
	local bufnr = vim.g.docusaurus_buffer
	if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		vim.notify(
			"Docusaurus server is running in buffer: " .. bufnr .. "\nBuffer Name: " .. bufname,
			vim.log.levels.INFO
		)
	else
		vim.notify("Docusaurus server buffer does not exist or is not valid.", vim.log.levels.ERROR)
	end
end

function OpenInDocusaurus()
	local projectDir = "D:\\notes\\KnowledgeBase\\Docs"
	-- local projectDir = "D:\\Users\\dylan\\Documents\\KnowledgeBase\\Docs"
	local filePath = vim.fn.expand("%:p") -- Get the full path of the current file

	-- Extract the relative path, replace backslashes with forward slashes
	local relativePath = filePath:sub(#projectDir + 2):gsub("\\", "/")

	-- Extract the directory path and the filename
	local dirPath, filename = relativePath:match("(.*/)([^/]+)$")

	-- Remove file extension from the filename
	if filename then
		filename = filename:gsub("%..*$", "")
	end

	-- URL encode the filename
	local encodedFilename = filename:gsub(" ", "%%20")

	-- Construct the full URL
	local url = "http://localhost:3000/" .. (dirPath or "") .. encodedFilename

	print("Opening URL: " .. url) -- Optional: For debugging
	vim.fn.system({ "cmd", "/c", "start", "", url })
end

-- they are not available
function _G.search_and_replace()
	local word = vim.fn.expand("<cword>")
	local cmd = ":%s/\\<" .. word .. "\\>/" .. word .. "/gIc"
	vim.cmd("echo") -- Clear any messages
	vim.api.nvim_feedkeys(":", "n", false)
	vim.api.nvim_feedkeys(cmd, "m", false)
	for i = 1, 5 do
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), "n", false)
	end
end

-- for autocommand on open
-- NOTE: escape sequence are probably way better than this
function _G.rename_tmux_pane()
	local current_file = vim.fn.expand("%:t") -- Get the current file name
	local parent_dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h:t") -- Get the parent directory name
	if current_file ~= "" and parent_dir ~= "" then
		os.execute('tmux rename-window " ' .. parent_dir .. "/" .. current_file .. '"')
	end
end

-- for autocommand on quit
function _G.reset_tmux_pane()
	-- Get the parent directory and current directory from within Neovim
	local parent_dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h:h:t")
	local current_dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h:t")
	-- Update the tmux window title to reflect the parent and current directory with the folder icon
	os.execute('tmux rename-window " ' .. parent_dir .. "/" .. current_dir .. '"')
end

function _G.reload_config()
	-- Step 1: Execute the command sequence
	local command_output = vim.fn.system("chezmoi apply && tmux source-file ~/.tmux.conf && source ~/.zshrc")
	if vim.v.shell_error ~= 0 then
		print("Error executing command sequence:", command_output)
		return
	end

	-- Save all open buffers
	vim.cmd("wa")

	-- Get the PID of the current nvim instance
	local nvim_pid = vim.fn.getpid()

	-- Start the restart script in the background, passing the current nvim PID as an argument, and disassociate from the current process
	local restart_command = string.format("!nohup ~/.config/scripts/reload-nvim.sh %d > /dev/null 2>&1 &", nvim_pid)
	vim.cmd(restart_command)

	-- Quit the current nvim instance
	vim.cmd("qa!")
end

function _G.SudoSave()
	-- Get the current file path
	local file_path = vim.fn.expand("%:p")

	-- If the file path is empty, then there's no file name specified
	if file_path == "" then
		vim.cmd('echoerr "No file name"')
		return
	end

	-- Escape spaces in the file path for the shell command
	local escaped_file_path = file_path:gsub(" ", "\\ ")

	-- Create the shell command to write the current buffer to the file with sudo rights
	local cmd = string.format("w !sudo tee %s > /dev/null", escaped_file_path)

	-- Execute the shell command
	vim.cmd(cmd)
end

function _G.SaveWindowsCreds()
	-- Get the current file path
	local file_path = vim.fn.expand("%:p")

	-- Check if the file path is not empty
	if file_path == "" then
		vim.cmd('echoerr "No file name"')
		return
	end

	-- Create a temporary file path
	-- Use the Windows path format and save to C:\temp
	-- Generate a random file name for the temporary file
	local random_file_name = "nvim_save_" .. os.tmpname():gsub("\\", ""):gsub("/", "")
	-- Combine with the desired directory path
	local tmp_file_path = "C:\\\\temp\\\\" .. random_file_name
	local wsl_tmp_file_path = "/mnt/c/temp/" .. random_file_name

	-- Write the current buffer to the temporary file
	vim.cmd("w " .. wsl_tmp_file_path)

	local home_dir = os.getenv("HOME")
	local wsl_ps_script_path = home_dir .. "/.config/windows/PowershellScripts/SaveAsAdmin.ps1"
	-- Translate WSL paths to Windows paths using wsl_to_win_path function
	local windows_tmp_file_path = wsl_to_win_path(wsl_tmp_file_path)
	local windows_file_path = wsl_to_win_path(file_path)
	local ps_script_path = wsl_to_win_path(wsl_ps_script_path)

	-- Check if the conversion was successful
	if not windows_tmp_file_path or not windows_file_path or not ps_script_path then
		vim.cmd('echoerr "Path conversion failed"')
		return
	end

	-- PowerShell script to prompt for credentials in a new window and copy the file
	-- Path to the PowerShell script
	-- Get the current user's home directory path

	-- Open a terminal buffer in Neovim and run the command
	vim.cmd("new")

	-- Construct the command to execute the PowerShell script
	local cmd = string.format(
		'powershell.exe -ExecutionPolicy Bypass -File "%s" -sourcePath "%s" -destinationPath "%s"',
		ps_script_path,
		windows_tmp_file_path,
		windows_file_path
	)
	--
	-- Debugging: print cmd to the Neovim command line
	-- vim.cmd('echo "' .. cmd .. '"')
	-- Open a terminal buffer in Neovim and run the command
	-- vim.fn.termopen(cmd)
	-- -- Open a terminal buffer in Neovim and run the command
	local job_id = vim.fn.termopen(cmd)

	-- Wait for the terminal job to finish (timeout set to 10 seconds, adjust as needed)
	local result = vim.fn.jobwait({ job_id }, 10000)[1]

	-- Close the terminal buffer
	-- Schedule the closure of the terminal buffer for the next event loop iteration
	vim.schedule(function()
		vim.cmd("bd!")
	end)

	-- Autoreload buffer correctly and bypass confirmation message
	if result == 0 then
		vim.cmd('echo "Copy with windows Creds Worked"')
		--BUG: not working, need to enforce reload automatically
		vim.cmd("silent! checktime")
	else
		vim.cmd('echoerr "Copy failed"')
	end
end
