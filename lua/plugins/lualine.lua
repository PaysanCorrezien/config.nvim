-- File where i ovveride default presets
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- table.remove(opts.sections.lualine_b)
      -- Inserting your custom function into lualine_c
      table.insert(opts.sections.lualine_a, {
        function()
          return require("NeoComposer.ui").status_recording()
        end,
      })
      table.insert(opts.sections.lualine_y, { "" })
      table.insert(opts.sections.lualine_y, { "encoding" })
      -- NOTE : Last commit date
      table.insert(opts.sections.lualine_b, {
        function()
          -- Define the Git command
          -- local git_command = 'git log -1 --format="%cd" --date=format:"%d/%m %H:%M" 2> nul' -- Adjusted for Windows
          -- Existing configuration and imports

          local git_command = 'git log -1 --format="%cd" --date=format:"%d/%m %H:%M" 2> /dev/null' -- Adjusted for Unix-like systems

          -- Attempt to execute the Git command
          local handle, err = io.popen(git_command)

          -- Check if the command execution was successful
          if handle then
            local result = handle:read("*a")
            handle:close()

            -- Remove any trailing newline character
            result = string.gsub(result, "\n", "")

            -- Git icon (adjust based on your font and preferences)
            local git_icon = " " -- Example icon using Nerd Fonts

            -- Return the git icon and formatted date or an empty string if result is empty
            return (result ~= "" and git_icon .. result) or ""
          else
            -- Log the error for debugging
            print("Error executing git command: " .. tostring(err))
            -- Return an empty string if handle is nil (command execution failed)
            return ""
          end
        end,
      })
    end,
  },
  -- WORK just fine
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options.numbers = "ordinal"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      { "<leader>/" , false },
      { "<leader>b", false },
      { "<leader>bd", false },
      { "<leader>bd", false },
      { "<leader>bD", false },
      { "<leader>be", false },
      { "<leader>bl", false },
      { "<leader>bo", false },
      { "<leader>bp", false },
      { "<leader>bP", false },
      { "<leader>br", false },
      {
        "<leader>b",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },

      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Search Word in Dir" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
      { "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      {
        "<leader>fP",
        function()
          require("telescope.builtin").live_grep({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Grep Plugin File",
      },
      {
        "<leader>fD",
        function()
          local path = jit.os:lower():find("windows") and "L:\\home\\dylan\\.local\\share\\chezmoi\\"
            or "/home/dylan/.local/share/chezmoi/"
          require("telescope.builtin").find_files({ cwd = path })
        end,
        desc = "DotFiles",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        -- layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          -- Define the comment text object inline
          k = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }, {}),
          P = ai.gen_spec.treesitter({
            a = { "@param.outer", "@assignment.outer" },
            i = { "@param.inner", "@assignment.inner" },
          }, {}),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      require("lazyvim.util").on_load("which-key.nvim", function()
        ---@type table<string, string|table>
        local i = {
          [" "] = "Whitespace",
          ['"'] = 'Balanced "',
          ["'"] = "Balanced '",
          ["`"] = "Balanced `",
          ["("] = "Balanced (",
          [")"] = "Balanced ) including white-space",
          [">"] = "Balanced > including white-space",
          ["<lt>"] = "Balanced <",
          ["]"] = "Balanced ] including white-space",
          ["["] = "Balanced [",
          ["}"] = "Balanced } including white-space",
          ["{"] = "Balanced {",
          ["?"] = "User Prompt",
          _ = "Underscore",
          a = "Argument",
          b = "Balanced ), ], }",
          c = "Class",
          f = "Function",
          o = "Block, conditional, loop",
          q = "Quote `, \", '",
          t = "Tag",
          k = "Comment",
          P = "exp/params",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end
        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs({ n = "Next", l = "Last" }) do
          i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
          a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        end
        require("which-key").register({
          mode = { "o", "x" },
          i = i,
          a = a,
        })
      end)
    end,
  },
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	-- event = { "LazyFile", "VeryLazy" },
  --
  -- 	-- Other configurations (like `version`, `build`, `event`, etc.) go here.
  -- 	-- ...
  --
  -- 	-- Custom function to set up keymaps for incremental selection
  -- 	opts = {
  --
  -- 		highlight = { enable = true },
  -- 		indent = { enable = true },
  -- 		ensure_installed = {
  -- 			"bash",
  -- 			"c",
  -- 			"diff",
  -- 			"html",
  -- 			"javascript",
  -- 			"jsdoc",
  -- 			"json",
  -- 			"jsonc",
  -- 			"lua",
  -- 			"luadoc",
  -- 			"luap",
  -- 			"markdown",
  -- 			"markdown_inline",
  -- 			"python",
  -- 			"query",
  -- 			"regex",
  -- 			"toml",
  -- 			"tsx",
  -- 			"typescript",
  -- 			"vim",
  -- 			"vimdoc",
  -- 			"yaml",
  -- 		},
  -- 		incremental_selection = {
  -- 			enable = true,
  -- 			keymaps = {
  -- 				init_selection = "<c-i>",
  -- 				node_incremental = "<c-i>",
  -- 				scope_incremental = false,
  -- 				node_decremental = "<bs>",
  -- 			},
  -- 		},
  -- 		textobjects = {
  -- 			move = {
  -- 				enable = true,
  -- 				goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
  -- 				goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
  -- 				goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
  -- 				goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
  -- 			},
  -- 		},
  -- 	},
  -- 	keys = {
  -- 		{ "<c-i>", desc = "Increment selection" },
  -- 		{ "<bs>", desc = "Decrement selection", mode = "x" },
  -- 	},
  -- },
}
