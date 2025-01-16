-- lua/plugins/chezmoi.lua
return {
  {
    "alker0/chezmoi.vim",
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = 1
      -- Use USERPROFILE environment variable for Windows
      local home_dir = os.getenv("USERPROFILE") or os.getenv("HOME")
      if home_dir then
        vim.g["chezmoi#source_dir_path"] = home_dir .. "\\.local\\share\\chezmoi"
      else
        vim.notify("Unable to determine home directory.", vim.log.levels.ERROR)
      end
    end,
  },
}
