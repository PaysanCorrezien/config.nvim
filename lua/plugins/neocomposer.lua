local function is_nixos()
  local os_name = vim.loop.os_uname().sysname
  return os_name == "Linux" and (vim.loop.os_uname().version:find("NixOS") ~= nil)
end

return {
  {
    "ecthelionvi/NeoComposer.nvim",
    enabled = is_nixos(),
    dependencies = { "kkharji/sqlite.lua" },
    lazy = false,
    opts = {},
    config = function()
      require("NeoComposer").setup()
    end,
    keys = {
      { "<leader>xm", "<cmd>:Telescope macros<cr>", desc = "Neo Macros" },
      { "<leader>xE", ":EditMacros<cr>", desc = "Edit Macros" },
    },
  },
}
