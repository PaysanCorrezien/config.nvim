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
}
