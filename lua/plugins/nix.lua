local function is_nixos()
  local os_name = vim.loop.os_uname().sysname

  return os_name == "Linux" and (vim.loop.os_uname().version:find("NixOS") ~= nil)
end

return {

  {
    "williamboman/mason.nvim",

    enabled = not is_nixos(), -- Disable Mason if the OS is NixOS
  },
  {
    "echasnovski/mini.animate",
    -- enabled = is_nixos(), -- Enable MiniAnimate if the OS is NixOS
    enabled = is_nixos(),
  },
}
