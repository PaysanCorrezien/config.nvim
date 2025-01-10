-- WSL and Windows specific settings
-- Workaround to use same config on both WSL and Windows
-- WIP - Not working yet
-- Function to get the current OS
local M = {}
function M.get_os()
  local uname = vim.loop.os_uname()
  local sysname = uname.sysname

  if sysname == "Windows_NT" then
    return "Windows"
  else
    -- Check if it is WSL
    local file = io.open("/proc/version", "r")
    if file then
      local version_info = file:read("*a")
      file:close()
      if version_info:find("Microsoft") then
        return "WSL"
      end
    end
    return "Linux"
  end
end

-- Function to get the current Windows username
function M.get_windows_username()
  -- Check the operating system
  local os_name = M.get_os()

  if os_name == "Windows" then
    -- Windows environment
    return vim.fn.getenv("USERNAME") or "default_username"
  elseif os_name == "Linux" then
    -- WSL environment: execute 'cmd.exe /c echo %USERNAME%'
    local handle = io.popen("cmd.exe /c echo %USERNAME%", "r")
    if handle then
      local username = handle:read("*a"):gsub("%s+", "") -- Remove extra whitespace
      handle:close()
      return username
    end
  end
  return "default_username"
end

-- Function to convert paths
function M.convert_path(path)
  local os = M.get_os()
  if os == "Windows" then
    return path:gsub("/", "\\")
  else
    return path:gsub("\\", "/")
  end
end

function M.to_wsl_path(windows_path)
  print("Type of windows_path: ", type(windows_path)) -- Debug statement

  if type(windows_path) ~= "string" then
    error("Invalid windows_path: Expected a string, got " .. type(windows_path))
  end

  local windows_username = M.get_windows_username()
  -- print("Type of windows_username: ", type(windows_username)) -- Debug statement

  if type(windows_username) ~= "string" then
    error("Invalid windows_username: Expected a string, got " .. type(windows_username))
  end

  local converted_path = windows_path:gsub("C:\\Users\\" .. windows_username, "/mnt/c/Users/" .. windows_username)
  -- print("Converted path: ", converted_path) -- Debug statement
  return converted_path
end

-- Function to convert WSL path to Windows path
function M.to_windows_path(wsl_path)
  local wsl_distribution = "Debian" -- Replace with your WSL distribution name
  local windows_path = "//wsl$/" .. wsl_distribution .. wsl_path
  return windows_path
end

-- Function to convert Windows path to WSL path

-- Updated Function to get settings
function M.get_setting(settings)
  -- print("DEBUG - get_setting input:", vim.inspect(settings))

  local os = M.get_os()
  -- print("DEBUG - Current OS:", os)

  if settings == nil then
    error("Settings parameter is nil")
  end

  -- If settings is a string, it's a path that needs conversion
  if type(settings) == "string" then
    -- print("DEBUG - Converting string path:", settings)
    if os == "Windows" then
      return M.to_windows_path(settings)
    else
      return M.to_wsl_path(settings)
    end
  end

  -- If settings is a table, get the OS-specific setting
  if type(settings) ~= "table" then
    error("Settings must be either a string or a table, got " .. type(settings))
  end

  local setting = settings[os]
  -- print("DEBUG - OS-specific setting:", vim.inspect(setting))

  if setting == nil and settings.default ~= nil then
    setting = settings.default
    -- print("DEBUG - Using default setting:", vim.inspect(setting))
  end

  if setting == nil then
    error(
      string.format(
        "No setting found for OS '%s' and no default provided. Available settings: %s",
        os,
        vim.inspect(vim.tbl_keys(settings))
      )
    )
  end

  if os == "Windows" and type(setting) == "string" then
    local username = M.get_windows_username()
    -- print("DEBUG - Windows username:", username)
    setting = setting:gsub("dylan", username)
  end

  if type(setting) == "string" then
    return M.convert_path(setting)
  end

  return setting
end

return M
