local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

--  windows utils
local os_utils = require("utils.os_utils")
local current_os = os_utils.get_os()

local function should_include_plugin(os_condition)
  if not os_condition then
    return true -- if no condition specified, always include
  end

  if type(os_condition) == "string" then
    return current_os == os_condition
  elseif type(os_condition) == "table" then
    for _, os in ipairs(os_condition) do
      if current_os == os then
        return true
      end
    end
  end
  return false
end

-- Filter plugins based on OS conditions
local function get_enabled_plugins(plugins)
  local enabled = {}
  for _, plugin in ipairs(plugins) do
    if should_include_plugin(plugin.enabled_on) then
      -- Remove the enabled_on field before adding to final list
      local plugin_copy = vim.tbl_extend("force", {}, plugin)
      plugin_copy.enabled_on = nil
      table.insert(enabled, plugin_copy)
    end
  end
  return enabled
end

require("lazy").setup({
  -- spec = {
  spec = get_enabled_plugins({
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    { import = "lazyvim.plugins.extras.ai.copilot" },
    -- { import = "lazyvim.plugins.extras.ai.copilot-chat" },
    { import = "lazyvim.plugins.extras.coding.mini-comment" }, -- comment with count ect
    { import = "lazyvim.plugins.extras.coding.neogen" },
    { import = "lazyvim.plugins.extras.coding.mini-surround" },

    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.dap.nlua" },
    -- { import = "lazyvim.plugins.extras.editor.aerial" },
    { import = "lazyvim.plugins.extras.editor.leap" }, --NOTE: SS tier navigation
    -- { import = "lazyvim.plugins.extras.editor.fzf" }, -- NOTE: fzf replace telescope
    { import = "lazyvim.plugins.extras.editor.inc-rename" }, -- NOTE: better lsp rename
    -- { import = "lazyvim.plugins.extras.editor.harpoon2" },
    { import = "lazyvim.plugins.extras.editor.illuminate" }, --NOTE: make the focused word occurence colored
    { import = "lazyvim.plugins.extras.editor.navic" }, --NOTE: topbar symbol info
    { import = "lazyvim.plugins.extras.editor.outline" }, --NOTE: add symbol menu
    { import = "lazyvim.plugins.extras.editor.overseer" },
    { import = "lazyvim.plugins.extras.editor.refactoring" },
    { import = "lazyvim.plugins.extras.editor.dial" },
    --
    { import = "lazyvim.plugins.extras.lsp.neoconf" },

    { import = "lazyvim.plugins.extras.lsp.none-ls" },

    { import = "lazyvim.plugins.extras.formatting.black" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },

    { import = "lazyvim.plugins.extras.lang.cmake" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.nix", enabled_on = "Linux" },
    -- { import = "lazyvim.plugins.extras.lang.nix" },

    { import = "lazyvim.plugins.extras.lang.sql" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.linting.eslint" },

    { import = "lazyvim.plugins.extras.test.core" },

    { import = "lazyvim.plugins.extras.ui.alpha" },
    { import = "lazyvim.plugins.extras.ui.mini-animate", enabled_on = "Linux" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.ui.mini-indentscope" },
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },

    { import = "lazyvim.plugins.extras.util.dot" },
    { import = "lazyvim.plugins.extras.util.octo" },
    -- { import = "lazyvim.plugins.extras.util.chezmoi" },
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },

    { import = "lazyvim.plugins.extras.coding.blink" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.nushell" },
    { import = "lazyvim.plugins.extras.ui.dashboard-nvim" },
    { import = "lazyvim.plugins.extras.util.rest" },
    { import = "lazyvim.plugins.extras.vscode" },

    -- import/override with your plugins
    { import = "plugins" },
  }),
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
