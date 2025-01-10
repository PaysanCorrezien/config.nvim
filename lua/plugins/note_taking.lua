local os_utils = require("utils.os_utils")

local function print_debug(name, value)
  print(string.format("DEBUG - %s: %s", name, vim.inspect(value)))
end

-- -- Debug prints for initialization
-- print_debug("Initial os_utils check", os_utils)
-- print_debug("get_os function check", os_utils.get_os)
-- print_debug("get_setting function check", os_utils.get_setting)

-- Safe environment variable getter
local function safe_getenv(var_name)
  local value = os.getenv(var_name)
  -- print_debug("Environment variable " .. var_name, value)
  return value or "" -- Return empty string if nil to prevent concatenation errors
end

-- Debug environment variables
-- print_debug("Environment variables", {
--   USERPROFILE = os.getenv("USERPROFILE"),
--   HOME = os.getenv("HOME"),
--   APPDATA = os.getenv("APPDATA"),
-- })

-- Path joining helper
local function join_path(...)
  local parts = { ... }
  print("DEBUG - Joining path parts:", vim.inspect(parts))
  return table.concat(parts, "\\")
end

-- OS-specific path builders
local path_builders = {
  Windows = function()
    return {
      home = safe_getenv("USERPROFILE"),
      notes = join_path(safe_getenv("USERPROFILE"), "Documents", "Notes"),
      projects = join_path(safe_getenv("USERPROFILE"), "Documents", "Projet", "Work", "Projet"),
      config = safe_getenv("APPDATA"),
    }
  end,
  WSL = function()
    return {
      home = safe_getenv("HOME"),
      notes = "/mnt/d/notes",
      projects = "/mnt/c/Users/" .. safe_getenv("USER") .. "/Documents/Projet/Work/Projet",
      config = safe_getenv("HOME") .. "/.config",
    }
  end,
  Linux = function()
    return {
      home = safe_getenv("HOME"),
      notes = safe_getenv("HOME") .. "/Documents/Notes",
      projects = safe_getenv("HOME") .. "/documents/Projet/Work/Projet",
      config = safe_getenv("HOME") .. "/.config",
    }
  end,
}

-- Get current OS paths
local current_os = os_utils.get_os()
-- print_debug("Current OS", current_os)

-- Configuration with lazy evaluation
local config = {
  base_paths = path_builders[current_os](),
}

-- print_debug("Full config", config.base_paths)

-- Path builder function
local function build_path(base, ...)
  local os_name = current_os
  -- print_debug("build_path call", {
  --   os_name = os_name,
  --   base = base,
  --   segments = { ... },
  -- })

  local base_path = config.base_paths[base]
  if not base_path then
    error("No base path found for: " .. base)
  end

  local segments = { ... }
  local final_path
  if os_name == "Windows" then
    final_path = base_path .. "\\" .. table.concat(segments, "\\")
  else
    final_path = base_path .. "/" .. table.concat(segments, "/")
  end

  -- print_debug("final_path", final_path)
  return final_path
end

-- Configuration builder
local function create_path_config()
  local paths = {
    obsidian = {
      vault = {
        Windows = build_path("notes"),
        WSL = build_path("notes"),
        Linux = build_path("notes"),
      },
      attachments = {
        Windows = build_path("notes", "static", "img"),
        WSL = build_path("notes", "static", "img"),
        Linux = build_path("notes", "3-Ressources", "Images"),
      },
      templates = {
        Windows = build_path("notes", "Projets", "Templates"),
        WSL = build_path("notes", "Projets", "Templates"),
        Linux = build_path("notes", "3-Ressources", "Templates"),
      },
    },
    pdftoppm = {
      Windows = build_path("home", "scoop", "shims", "pdftoppm.exe"),
      WSL = "/usr/bin/pdftoppm",
      Linux = build_path("home", ".nixprofile", "bin", "pdftoppm"),
    },
    plugins = {
      pdf = {
        Windows = build_path("projects", "pdf.nvim"),
        WSL = build_path("projects", "pdf.nvim"),
        Linux = build_path("projects", "pdf.nvim"),
      },
      dictionary = {
        Windows = build_path("projects", "dictionary.nvim"),
        WSL = build_path("projects", "dictionary.nvim"),
        Linux = build_path("projects", "dictionary.nvim"),
      },
    },
    dictionaries = {
      remote_ltex_ls = {
        Windows = build_path("config", "nvim", "spells", "ltex.dictionary.fr.txt"),
        WSL = build_path("config", "nvim", "spells", "ltex.dictionary.fr.txt"),
        Linux = build_path("config", "nvim", "spells", "ltex.dictionary.fr.txt"),
      },
      remote_spell = {
        Windows = build_path("config", "nvim", "spells", "spell.utf-8.add"),
        WSL = build_path("config", "nvim", "spells", "spell.utf-8.add"),
        Linux = build_path("config", "nvim", "spells", "spell.utf-8.add"),
      },
      local_ltex_ls = {
        Windows = build_path("config", "nvim", "dict", "ltex.dictionary.fr.txt"),
        WSL = build_path("config", "nvim", "dict", "ltex.dictionary.fr.txt"),
        Linux = build_path("config", "nvim", "dict", "ltex.dictionary.fr.txt"),
      },
      local_spell = {
        Windows = build_path("config", "nvim", "dict", "spell.utf-8.add"),
        WSL = build_path("config", "nvim", "dict", "spell.utf-8.add"),
        Linux = build_path("config", "nvim", "dict", "spell.utf-8.add"),
      },
    },
    ltex_extra = {
      Windows = build_path("config", "nvim", "dict"),
      Linux = build_path("config", "nvim", "spell"),
    },
  }

  -- Helper function to get settings
  local function get_paths(path_table)
    if not path_table then
      error("path_table is nil")
    end
    -- print("DEBUG - get_paths input:", vim.inspect(path_table))
    local result = os_utils.get_setting(path_table)
    -- print("DEBUG - get_paths result:", vim.inspect(result))
    return result
  end

  local final_config = {
    obsidian_vault_path = get_paths(paths.obsidian.vault),
    obsidian_attachments_path = get_paths(paths.obsidian.attachments),
    templates_path = get_paths(paths.obsidian.templates),
    pdftoppm_path = get_paths(paths.pdftoppm),
    pdf_plugin_path = get_paths(paths.plugins.pdf),
    dictionary_plugin_path = get_paths(paths.plugins.dictionary),
    remote_ltex_ls = get_paths(paths.dictionaries.remote_ltex_ls),
    remote_spell = get_paths(paths.dictionaries.remote_spell),
    local_ltex_ls = get_paths(paths.dictionaries.local_ltex_ls),
    local_spell = get_paths(paths.dictionaries.local_spell),
    ltex_extra_cwd = get_paths(paths.ltex_extra),
  }

  -- -- Debug prints
  -- print_debug("OS", os_utils.get_os())
  -- for key, value in pairs(final_config) do
  --   print_debug(key, value)
  -- end

  return final_config
end

-- Usage example:
local paths = create_path_config()

return {
  {
    "barreiroleo/ltex_extra.nvim",
    lazy = true,
    -- TODO: remove when PR merged

    commit = "6d00bf2fbd6fcecafd052c0e0f768b67ceb3307f",
    ft = { "markdown", "tex" },
    dependencies = { "neovim/nvim-lspconfig" },
    -- yes, you can use the opts field, just I'm showing the setup explicitly
    config = function()
      require("ltex_extra").setup({
        -- your_ltex_extra_opts,
        -- table <string> : languages for witch dictionaries will be loaded, e.g. { "es-AR", "en-US" }
        -- https://valentjn.github.io/ltex/supported-languages.html#natural-languages
        load_langs = { "fr", "en" }, -- en-US as default
        -- boolean : whether to load dictionaries on startup
        init_check = true,
        -- string : relative or absolute paths to store dictionaries
        -- e.g. subfolder in current working directory: ".ltex"
        -- e.g. shared files for all projects :  vim.fn.expand("~") .. "/.local/share/ltex"
        path = paths.ltex_extra_cwd,
        -- path = "~/.config/lvim/dict", -- current working directory
        -- cant work because \\\\ are poorly interpreted
        -- path = "\\\\wsl.localhost\\Debian\\home\\dylan\\.config\\lvim\\dict",
        -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
        log_level = "none",
        -- table : configurations of the ltex language server.
        -- Only if you are calling the server from ltex_extra
        server_opts = {
          -- capabilities = your_capabilities,
          on_attach = function(client, bufnr)
            -- your on_attach process
          end,
          settings = {
            ltex = {
              -- cmd = { "/home/dylan/.local/share/nvim/lsp_servers/ltex/ltex-ls/bin/ltex-ls" },
              language = "en",
              diagnosticSeverity = "information",
              setenceCacheSize = 2000,
              additionalRules = {
                enablePickyRules = true,
                motherTongue = "fr",
              },
              -- trace = { server = "verbose" },
              -- dictionary = "~/.config/lvim/dict/", -- added global dictionary path
              completionEnabled = "true",
              checkfrenquency = "edit",
              statusBarItem = "true",
              disabledRules = {},
              -- hiddenFalsePositives = {},
            },
          },
        },
      })
    end,
  },
  -- {
  -- 	-- dir = dictionary_plugin_path, -- DEV : use local path
  -- 	"paysancorrezien/dictionary.nvim", -- PROD : use remote path
  -- 	ft = "markdown",
  -- 	dependencies = {
  -- 		"nvim-lua/plenary.nvim",
  -- 	},
  -- 	config = function()
  -- 		require("dictionary").setup({
  -- 			dictionary_paths = {
  -- 				remote_ltex_ls,
  -- 				remote_spell,
  -- 				local_ltex_ls,
  -- 				local_spell,
  -- 			},
  -- 			override_zg = true,
  -- 			ltex_dictionary = true, -- if you are use ltex-ls extra and want to use zg to also update ltex-ls dictionary
  -- 			cmp = {
  -- 				enabled = true,
  -- 				custom_dict_path = local_ltex_ls,
  -- 				max_spell_suggestions = 10,
  -- 				filetypes = { "markdown", "tex" },
  -- 				priority = 20000,
  -- 				name = "dictionary",
  -- 				source_label = "[Dict]",
  -- 				-- kind_icon = cmp.lsp.CompletionItemKind.Event, -- Icon for suggestions
  -- 				-- kind_icon = " ", -- Icon need to be registered on lsp icons
  -- 			},
  -- 		})
  -- 	end,
  -- },
  -- -- register custom cmp for dict
  -- {
  -- 	"nvim-cmp",
  -- 	dependencies = {},
  -- 	opts = function(_, opts)
  -- 		-- Add the obsidian sources to CMP
  -- 		-- table.insert(opts.sources, { name = "obsidian", priority = 100 })
  -- 		-- table.insert(opts.sources, { name = "obsidian_new", priority = 100 })
  -- 		-- table.insert(opts.sources, { name = "obsidian_tags", priority = 100 })
  --
  -- 		-- Add the dictionary source to CMP
  -- 		table.insert(opts.sources, 1, {
  -- 			name = "dictionary",
  -- 			priority = 20000, -- Custom priority
  -- 		})
  --
  -- 		-- Custom formatting for dictionary items
  -- 		local existing_formatting_function = opts.formatting.format
  -- 		opts.formatting.format = function(entry, vim_item)
  -- 			if entry.source.name == "dictionary" then
  -- 				-- vim_item.kind = cmp.lsp.CompletionItemKind.Text -- this make crash
  -- 				vim_item.menu = "[Dict]" -- Custom label
  -- 			elseif existing_formatting_function then
  -- 				vim_item = existing_formatting_function(entry, vim_item)
  -- 			end
  -- 			return vim_item
  -- 		end
  -- 	end,
  -- },

  {
    -- dir = pdf_plugin_path, -- DEV : use local path
    "paysancorrezien/pdf.nvim", -- PROD : use remote path
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("pdf").setup({
        pdf_path = paths.obsidian_attachments_path,
        image_path = paths.obsidian_attachments_path,
        pdftoppm_path = paths.pdftoppm_path,
        new_link_format = function(prefix, text, generated_image_file)
          return prefix .. "[" .. text .. "](/3-Ressources/Images/" .. generated_image_file .. ")"
        end,
      })
    end,
  },
  -- {
  -- 	"renerocksai/telekasten.nvim",
  -- 	dependencies = { "nvim-telescope/telescope.nvim" },
  -- 	config = function()
  -- 		require("telekasten").setup({
  -- 			home = obsidian_vault_path,
  -- 		})
  -- 	end,
  -- },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      -- Required
      "nvim-lua/plenary.nvim",
      -- Optional, for completion
      "hrsh7th/nvim-cmp",
      -- Optional, for search and quick-switch functionality
      "nvim-telescope/telescope.nvim",
      -- New dependencies from the example
      "saghen/blink.cmp",
      "saghen/blink.compat",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = paths.obsidian_vault_path,
        },
      },
      completion = {
        nvim_cmp = false, -- Disable built-in completion as we'll set it up manually
        min_chars = 1,
      },
      attachments = {
        img_folder = paths.obsidian_attachments_path,
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![%s](%s)", path.name, path)
        end,
      },
      note_frontmatter_func = function(note)
        local out = {}
        out["title"] = note.id
        out["tags"] = note.tags
        out["date"] = os.date("%Y-%m-%d %H:%M")
        out["personal_only"] = true
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
      ui = {
        enable = true,
      },
      templates = {
        subdir = paths.templates_path,
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      sort_by = "modified",
      sort_reversed = true,
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>zx"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
      -- Set up manual completion sources
      local cmp = require("cmp")
      cmp.register_source("obsidian", require("cmp_obsidian").new())
      cmp.register_source("obsidian_new", require("cmp_obsidian_new").new())
      cmp.register_source("obsidian_tags", require("cmp_obsidian_tags").new())
    end,
    init = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>z", group = "+NoteTaking", icon = " " },
      })
    end,
    keys = {
      { "<leader>zf", "<cmd>ObsidianQuickSwitch<CR>", desc = "Find Notes" },
      { "<leader>zG", "<cmd>ObsidianSearch<CR>", desc = "Grep Notes" },
      { "<leader>zg", "<cmd>ObsidianFollowLink<CR>", desc = "Follow Link", mode = { "n", "v" } },
      { "<leader>zz", "<cmd>ObsidianBacklinks<CR>", desc = "List Link" },
      { "<leader>zC", "<cmd>ObsidianCheck<CR>", desc = "Checks" },
      { "<leader>zi", "<cmd>ObsidianPasteImg<CR>", desc = "Insert IMG" },
      {
        "<leader>zR",
        function()
          local input = vim.fn.input("Enter new note title: ")
          if input ~= "" then
            vim.cmd("ObsidianRename" .. input)
          end
        end,
        desc = "Rename",
      },
      { "<leader>zt", "<cmd>ObsidianTemplate<CR>", desc = "Template" },
      { "<leader>zT", "<cmd>ObsidianTemplate knowledge.md<CR>", desc = "Default Template" },
      -- [Rest of your existing key mappings...]
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.compat" },
    opts = {
      sources = {
        default = { "obsidian", "obsidian_new", "obsidian_tags" },
        providers = {
          obsidian = {
            name = "obsidian",
            module = "blink.compat.source",
          },
          obsidian_new = {
            name = "obsidian_new",
            module = "blink.compat.source",
          },
          obsidian_tags = {
            name = "obsidian_tags",
            module = "blink.compat.source",
          },
        },
      },
    },
  },
  --   -- {
  --   -- 	"mfussenegger/nvim-lint",
  --   -- 	optional = true,
  --   -- 	opts = {
  --   -- 		linters_by_ft = {
  --   -- 			markdown = { "markdownlint" },
  --   -- 		},
  --   -- 	},
  --   -- 	config = function()
  --   -- 		local markdownlint_config_path = vim.fn.stdpath("config") .. "\\extconfigs\\markdownlint.jsonc"
  --   -- 		require("lint").linters.markdownlint = {
  --   -- 			cmd = "markdownlint",
  --   -- 			stdin = false,
  --   -- 			args = { "--config", markdownlint_config_path, "%filepath" },
  --   -- 		}
  --   -- 	end,
  --   -- },
  --   -- {
  --   -- 	"neovim/nvim-lspconfig",
  --   -- 	opts = {
  --   -- 		servers = {
  --   -- 			marksman = {},
  --   -- 		},
  --   -- 	},
  --   -- 	-- TODO :make it use conf without breaking lsp
  --   -- 	-- config = function()
  --   -- 	--   local marksman_config_path = vim.fn.stdpath("config") .. "\\extconfigs\\marksman.toml"
  --   -- 	--   print("Marksman config path: " .. marksman_config_path) -- Debug print
  --   -- 	--   require("lspconfig").marksman.setup({})
  --   -- 	-- end,
  --   -- },
  --
  --   -- { "mrjones2014/smart-splits.nvim" }, --TODO
}
