return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "VeryLazy",
    -- opts = {
    -- 	suggestion = { enabled = false },
    -- 	panel = { enabled = false },
    -- 	filetypes = {
    -- 		markdown = true,
    -- 		help = true,
    -- 	},
    -- },
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            -- open = "<leader>cC",
          },
          layout = {
            position = "right", -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-m>",
            accept_word = "<C-w>",
            accept_line = false,
            next = "<C-]>",
            prev = "<C-[>",
            dismiss = "<C-d>",
          },
        },
        copilot_node_command = "node", -- Node.js version must be > 18.x
        server_opts_overrides = {},

        filetypes = {
          markdown = true, -- overrides default
          terraform = false, -- disallow specific filetype
          yaml = false,
          sh = function()
            if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
              -- disable for .env files
              return false
            end
            return true
          end,
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    enabled = false,
  },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "canary",
  --   dependencies = {
  --     { "nvim-telescope/telescope.nvim" },
  --     { "nvim-lua/plenary.nvim" },
  --   },
  --   opts = {
  --     model = "claude-3.5-sonnet",
  --     prompts = {
  --       -- Only define system prompts, not user prompts
  --       NixExpert = {
  --         system_prompt = "You are an expert in NixOS, Nix language, and Nix Flakes. You understand NixOS modules, packaging, and common deployment patterns. You provide clear, practical advice while following NixOS best practices and conventions. You analyze configurations with attention to security, maintainability, and NixOS idioms.",
  --       },
  --       FileExpert = {
  --         system_prompt = "You are an expert code analyzer with deep understanding of software architecture, design patterns, and best practices. You provide detailed insights about code structure, potential improvements, and maintain awareness of the broader context of the file within its project.",
  --       },
  --       ProjectExpert = {
  --         system_prompt = "You are an expert system architect with deep understanding of project structures, codebases, and software architecture. You excel at analyzing relationships between components, identifying patterns, and suggesting architectural improvements while considering the full context of the project.",
  --       },
  --     },
  --   },
  --   keys = {
  --     {
  --       "<leader>af",
  --       function()
  --         local input = vim.fn.input("Chat about file: ")
  --         if input ~= "" then
  --           require("CopilotChat").ask(input, {
  --             selection = require("CopilotChat.select").buffer,
  --             system_prompt = "/FileExpert",
  --           })
  --         end
  --       end,
  --       desc = "Copilot Chat - Current File",
  --     },
  --     {
  --       "<leader>aP",
  --       function()
  --         local input = vim.fn.input("Chat about project: ")
  --         if input ~= "" then
  --           require("CopilotChat").ask(input, {
  --             context = "#files",
  --             system_prompt = "/ProjectExpert",
  --           })
  --         end
  --       end,
  --       desc = "Copilot Chat - Project Overview",
  --     },
  --     {
  --       "<leader>an",
  --       function()
  --         local input = vim.fn.input("Nix question: ")
  --         if input ~= "" then
  --           require("CopilotChat").ask(input, {
  --             selection = require("CopilotChat.select").buffer,
  --             system_prompt = "/NixExpert",
  --           })
  --         end
  --       end,
  --       desc = "Copilot Chat - Nix Helper",
  --     },
  --   },
  --   config = function(_, opts)
  --     local chat = require("CopilotChat")
  --     chat.setup(opts)
  --
  --     -- Commands mirror the keybinding functionality
  --     vim.api.nvim_create_user_command("CopilotChatFile", function()
  --       local input = vim.fn.input("Chat about file: ")
  --       if input ~= "" then
  --         chat.ask(input, {
  --           selection = require("CopilotChat.select").buffer,
  --           system_prompt = "/FileExpert",
  --         })
  --       end
  --     end, {})
  --
  --     vim.api.nvim_create_user_command("CopilotChatProject", function()
  --       local input = vim.fn.input("Chat about project: ")
  --       if input ~= "" then
  --         chat.ask(input, {
  --           context = "#files",
  --           system_prompt = "/ProjectExpert",
  --         })
  --       end
  --     end, {})
  --
  --     vim.api.nvim_create_user_command("CopilotChatNix", function()
  --       local input = vim.fn.input("Nix question: ")
  --       if input ~= "" then
  --         chat.ask(input, {
  --           selection = require("CopilotChat.select").buffer,
  --           system_prompt = "/NixExpert",
  --         })
  --       end
  --     end, {})
  --   end,
  -- },
}
