--NOTE: for windows:
-- scoop install main/sqlite
--TODO: fix the path for the sqlite3.dll
local os_utils = require("utils.os_utils")
local home = os.getenv("HOME") or "~"
local appdata = os.getenv("APPDATA") or ""

local function download_if_missing_windows(url, dest_path)
  if vim.fn.filereadable(dest_path) == 0 then
    local ps_cmd = string.format(
      [[
            powershell.exe -NoProfile -Command "
                $ProgressPreference = 'SilentlyContinue'
                if (-not (Test-Path '%s')) {
                    New-Item -ItemType Directory -Force -Path (Split-Path -Path '%s')
                    Invoke-WebRequest -Uri '%s' -OutFile '%s'
                }
            "]],
      dest_path,
      dest_path,
      url,
      dest_path
    )
    os.execute(ps_cmd)
  end
end

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

vim.g.my_ltexfile_path = remote_ltex_ls
vim.g.my_spellfile_path = remote_spell
vim.g.notes_path = notes_path
vim.opt.spellfile = remote_spell

local current_os = os_utils.get_os()
if current_os == "Windows" then
  local windows_username = os_utils.get_windows_username()
  local sqlite_clib_path = "C:/Users/" .. windows_username .. "/AppData/Roaming/sqlite-dll/sqlite3.dll"
  vim.g.sqlite_clib_path = sqlite_clib_path
  vim.g.python3_host_prog = "C:\\python312\\python.exe"

  -- Download French spell files if missing
  local spell_dir = appdata .. "\\nvim\\spell"
  download_if_missing_windows("https://ftp.nluug.nl/vim/runtime/spell/fr.utf-8.spl", spell_dir .. "\\fr.utf-8.spl")
  download_if_missing_windows("https://ftp.nluug.nl/vim/runtime/spell/fr.utf-8.sug", spell_dir .. "\\fr.utf-8.sug")

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
vim.opt.spellfile = remote_spell
vim.opt.spell = true
vim.opt.spelllang = { "en", "fr" }
vim.opt.spellsuggest = { "double", 9 }
vim.opt.cursorline = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
