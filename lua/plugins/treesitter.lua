return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Configuring the rest of nvim-treesitter settings
    config = function(plugin, opts)
      opts = {
        ensure_installed = {
          -- Common formats
          "yaml",
          "json",
          "toml",
          "dockerfile",

          -- Shell/Scripts
          "bash",
          "powershell",

          -- Programming
          "c",
          "cmake",
          "cpp",
          "python",
          "lua",
          "javascript",
          "typescript",
          "astro",
          "go",
          "rust",

          -- Vim
          "vim",
          "vimdoc",

          -- Markup
          "markdown",
          "markdown_inline",
          "regex",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-m>",
            node_incremental = "<C-m>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]k"] = "@comment.outer",
              ["]A"] = "@parameter.inner",
              ["]m"] = "@function.outer",
              ["]o"] = "@loop.*",
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]M"] = "@function.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[k"] = "@comment.outer",
              ["[A"] = "@parameter.inner",
              ["[m"] = "@function.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[M"] = "@function.outer",
            },
            goto_next = {
              ["]D"] = "@conditional.outer",
            },
            goto_previous = {
              ["[D"] = "@conditional.outer",
            },
          },
        },
      }
      require("nvim-treesitter.configs").setup(opts)
    end,
    -- Keybindings and other specifications
    keys = {
      { "<c-m>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
  },
}
