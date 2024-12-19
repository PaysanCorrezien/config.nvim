--NOTE: for windows:
-- DOWNLOAD SPELL FILES
-- Invoke-WebRequest -Uri "https://ftp.nluug.nl/vim/runtime/spell/fr.utf-8.spl" -OutFile "$env:LOCALAPPDATA\nvim\spell\fr.utf-8.spl"
-- Invoke-WebRequest -Uri "https://ftp.nluug.nl/vim/runtime/spell/fr.utf-8.sug" -OutFile "$env:LOCALAPPDATA\nvim\spell\fr.utf-8.sug"
--
local os_utils = require("utils.os_utils")
local home = os.getenv("HOME") or "~"
local appdata = os.getenv("APPDATA") or ""

vim.g.python3_host_prog = home .. "/.pyenv/versions/3.10.4/bin/python"

local dictionaries_files_path = {
  remote_ltex_ls = {
    Windows = appdata .. "\\nvim\\spells\\ltex.dictionary.fr.txt",
    WSL = home .. "/.config/nvim/spells/ltex.dictionary.fr.txt",
    Linux = home .. "/.config/nvim/spells/ltex.dictionary.fr.txt",
  },
  remote_spell = {
    Windows = appdata .. "\\nvim\\spells\\spell.utf-8.add",
    WSL = home .. "/.config/nvim/spells/spell.utf-8.add",
    Linux = home .. "/.config/nvim/spells/spell.utf-8.add",
  },
  notes_path = {
    Windows = "Z:\\notes",
    WSL = home .. "/.local/share/chezmoi/dot_config/lvim/dict/",
    Linux = home .. "/.local/share/chezmoi/dot_config/lvim/dict/",
  },
}

local remote_ltex_ls = os_utils.get_setting(dictionaries_files_path.remote_ltex_ls)
local remote_spell = os_utils.get_setting(dictionaries_files_path.remote_spell)
local notes_path = os_utils.get_setting(dictionaries_files_path.notes_path)

local current_os = os_utils.get_os()

if current_os == "Windows" then
  local windows_username = os_utils.get_windows_username()
  local sqlite_clib_path = "C:/Users/" .. windows_username .. "/AppData/Roaming/sqlite-dll/sqlite3.dll"
  vim.g.sqlite_clib_path = sqlite_clib_path
  vim.g.python3_host_prog = "C:\\python312\\python.exe"
  vim.opt.spelllang = {} -- disable spell check for windows
  vim.opt.spell = false

  local powershell_options = {
    shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
else
  vim.g.my_ltexfile_path = remote_ltex_ls
  vim.g.my_spellfile_path = remote_spell
  vim.g.notes_path = notes_path
  vim.opt.spellfile = remote_spell

  vim.opt.spellfile = remote_spell
  vim.opt.spell = true
  vim.opt.spelllang = { "en", "fr" }
  vim.opt.spellsuggest = { "double", 9 }
  local sql_clib_path = vim.env.SQL_CLIB_PATH
  if sql_clib_path and sql_clib_path ~= "" then
    vim.g.sqlite_clib_path = sql_clib_path
    print("SQL_CLIB_PATH set to: " .. vim.g.sqlite_clib_path)
  else
    print("Warning: SQL_CLIB_PATH is not set.")
  end
end

vim.log.level = "warn"
vim.opt.clipboard = ""
vim.opt.cursorline = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Set NetRW to use `ls -al` for remote directory listings to display detailed info
vim.g.netrw_sort_by = "time" -- Sort by modification time
-- vim.g.netrw_list_cmd = "ls -al" -- Use `ls -al` specifically for local testing
vim.g.netrw_localcopycmdopt = "" -- Reset any potential interference with local options
vim.g.netrw_localmovecmdopt = "" -- Reset move command options
vim.g.netrw_liststyle = 1 -- Enforce long listing style
