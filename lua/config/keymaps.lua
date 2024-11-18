-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Changelog removal

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "NZzzv")
vim.keymap.set("n", "%", "%zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "gg", "ggzz")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "zj", "o<Esc>k") -- insert line down without leaver n mode
vim.keymap.set("n", "zk", "O<Esc>j") -- insert line up without leaver n mode
-- vim.keymap.set("n", "<leader>Zd", '"_d')
-- vim.keymap.set("v", "<leader>Zd", '"_d')
-- Use <C-B> (or <C-S-b> in some terminals) for visual block mode
vim.keymap.set("n", "<C-b>", "<C-v>")
vim.keymap.set("i", "<C-c>", "<Esc>")
-- vim.keymap.set("n", "<leader>S", "<cmd>%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gIc<Left><Left><Left><Left><Left><cr>") -- search and replace with highlight and confirmation
vim.keymap.set("n", "<S-Up>", "ddkP") --move line up on normal mode with shift
vim.keymap.set("n", "<S-Down>", "ddp") --move line down on normal mode with shift
vim.api.nvim_set_keymap("n", "<C-a>", ':lua vim.cmd("normal! ggVG")<CR>', { noremap = true }) -- Select ALL

vim.keymap.set("n", "L", "vg_", { desc = "Select to end of line" })
-- Normal mode mappings
-- vim.keymap.set("n", "<leader>8", "<cmd>TodoTelescope<cr>", { desc = "Todo Current Project" })
-- vim.keymap.set("n", "<leader>S", function()
-- 	local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gcI<Left><Left><Left><Left>"
-- 	local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
-- 	vim.api.nvim_feedkeys(keys, "n", false)
-- end, { desc = "Search and replace" })
-- Open Spectre for global find/replace

-- vim.keymap.set("n", "<leader>/", function()
-- 	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
-- 		previewer = false,
-- 	}))
-- end, { desc = "[/] Fuzzily search in current buffer]" })

-- vim.keymap.set("n", "<leader>zs", function()
-- 	require("fzf-lua").spell_suggest({
-- 		previewer = true,
-- 	})
-- end, { desc = "Spell suggestions" })
vim.keymap.set("n", "<leader>zs", function()
  require("telescope.builtin").spell_suggest(require("telescope.themes").get_dropdown({
    previewer = true,
  }))
end, { desc = "Spell suggestions" })

-- vim.keymap.set("n", "<leader>A", "<cmd>:lua require('harpoon.mark').add_file()<CR>", { desc = "Harp Add" })
-- vim.keymap.set("n", "<leader>H", "<cmd>:Telescope harpoon marks<CR>", { desc = "List Harp Mark" })
-- vim.keymap.set("n", "<leader>j", "<cmd>Telescope jumplist<CR>", { desc = "Jumplist" })
vim.keymap.set("n", "<leader>X", ":lua RunPowershellCommand()<CR>", { desc = "Run PowerShell Command" })
vim.keymap.set("n", "<leader>W", ":lua SudoSave()<CR>", { desc = "Save with Sudo" })
vim.keymap.set("n", "<leader>M", ":lua SaveWindowsCreds()<CR>", { desc = "Save with Windows Credentials" })
-- vim.keymap.set("n", "<leader>R", ":lua reload_config()<CR>", { desc = "Reload Conf" })
-- vim.keymap.set("n", "<leader>G", "<cmd>Git<CR>", { desc = "Git" })
-- vim.keymap.set("n", "<leader>gv", "<cmd>!git commit <CR>", { desc = "Git commit" })
-- vim.keymap.set("n", "<leader>ga", "<cmd>Git add .<CR>", { desc = "Git Add ALL" })
vim.keymap.set("n", "<leader>gL", "<cmd>Gitsigns setloclist<CR>", { desc = "Git LocList" })

-- Visual mode mappings
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy Y", silent = true })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy Y" })
-- BufferLine mappings
-- for tab number
--
--NOTE: trying to unlearn bad habit
for i = 1, 7 do
  vim.keymap.set("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<CR>", { desc = "Go To Tab " .. i })
end

-- Move Lines
vim.keymap.set("n", "<C-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<C-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<C-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<C-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

--BUG: not working
-- vim.keymap.set("n", "<leader>cP", "<cmd>put =expand('%:p:h')<CR>", { desc = "Full Path" })
-- vim.keymap.set("n", "<leader>cP", "<cmd>put =expand('%:h')<CR>", { desc = "Copy CWD" })

-- -- Mapping to start the Docusaurus server
-- vim.keymap.set("n", "<leader>zX", function()
-- 	StartDocusaurusServer()
-- end, { desc = "Start Docusaurus Server" })

-- Mapping to open the current file in Docusaurus
-- vim.keymap.set("n", "<leader>zo", function()
-- 	OpenInDocusaurus()
-- end, { desc = "Open in Docusaurus" })
--
-- vim.api.nvim_set_keymap("n", "<leader>zD", ":lua StartDocusaurusServer()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>zd", ":lua StopDocusaurusServer()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>zX", ":lua GetDocusaurusBufferInfo()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>zN", ":lua CreateNote()<CR>", { noremap = true, silent = true })

-- Comment toggle auto for multimode in a single key
--NOTE: magic binding one key do all
local function comment_toggle()
  local mode = vim.fn.mode()

  -- print("mode before the action " .. mode)
  if mode == "n" then
    -- Normal mode
    -- No count, current line
    return "<Plug>(comment_toggle_linewise_current)"
  elseif mode == "v" then
    -- Visual mode
    -- Correcting the toggle for visual mode
    return "<Plug>(comment_toggle_linewise_visual)gv"
  elseif mode == "V" then
    -- Visual mode
    -- Correcting the toggle for visual mode
    return "<Plug>(comment_toggle_linewise_visual)gv"
  elseif mode == "CTRL-V" then
    -- Visual block mode
    return "<Plug>(comment_toggle_blockwise_visual)gv"
  elseif mode == "i" then
    -- Insert mode
    -- Comment the current line and return to normal mode
    return "<Esc><Plug>(comment_toggle_linewise_current)"
  end
end

vim.keymap.set({ "n", "x", "i" }, "<C-z>", comment_toggle, { expr = true, silent = true })

-- vim.api.nvim_create_user_command("OverseerRestartLast", function()
-- 	local overseer = require("overseer")
-- 	local tasks = overseer.list_tasks({ recent_first = true })
-- 	if vim.tbl_isempty(tasks) then
-- 		vim.notify("No tasks found", vim.log.levels.WARN)
-- 	else
-- 		overseer.run_action(tasks[1], "restart")
-- 	end
-- end, {})
-- vim.keymap.set("n", "<leader>cR", ":OverseerRestartLast<CR>", { desc = "Restart last task" })

-- vim.keymap.set("n", "<leader>cT", "<cmd>TroubleToggle workspace_diagnostic<CR>", { desc = "TroubleProjet" })
-- vim.keymap.set("n", "<leader>ct", "<cmd>TroubleToggle document_diagnostic<CR>", { desc = "TroubleLocal" })

local function copyDiagnosticsToClipboard()
  local bufnr = vim.api.nvim_get_current_buf()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = line - 1 })

  local messages = {}
  for _, diag in ipairs(diagnostics) do
    table.insert(messages, diag.message)
  end

  local final_message = table.concat(messages, "\n")
  vim.fn.setreg("+", final_message) -- Copy to clipboard

  print("Diagnostics copied to clipboard") -- Optional: Confirmation message
end

vim.keymap.set("n", "<leader>cz", copyDiagnosticsToClipboard, { desc = "Copy LSP Diagnostics to Clipboard" })

vim.keymap.set("n", "<leader>S", function()
  local grug_far = require("grug-far")
  grug_far.grug_far({
    prefills = {
      search = vim.fn.expand("<cword>"),
      paths = vim.fn.expand("%"),
    },
  })
end, { desc = "Search current word in current file with grug-far" })

vim.keymap.set(
  "n",
  "<leader>fN",
  ':let @+ = expand("%:p")<cr>:lua print("Copied path to: " .. vim.fn.expand("%:p"))<cr>',
  { desc = "Copy current file name and path", silent = false }
)

-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set("n", "<C-S-h>", require("smart-splits").resize_left)
vim.keymap.set("n", "<C-S-j>", require("smart-splits").resize_down)
vim.keymap.set("n", "<C-S-k>", require("smart-splits").resize_up)
vim.keymap.set("n", "<C-S-l>", require("smart-splits").resize_right)
-- moving between splits
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
-- vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
-- swapping buffers between windows
-- vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
-- vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
-- vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
-- vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
local function open_netrw_remote_home()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  -- Fetch list of SSH hosts from known_hosts or ssh config
  local ssh_hosts = {}
  local handle = io.popen("awk '{print $1}' ~/.ssh/known_hosts | cut -d ',' -f 1")
  if handle then
    for line in handle:lines() do
      table.insert(ssh_hosts, line)
    end
    handle:close()
  end

  -- Telescope picker for SSH hosts
  pickers
    .new({}, {
      prompt_title = "Select SSH Host",
      finder = finders.new_table({
        results = ssh_hosts,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local host = selection[1]

          -- Prompt for username with "dylan" preset
          vim.ui.input({ prompt = "Enter username: ", default = "dylan" }, function(user)
            if not user or user == "" then
              return
            end

            -- Open NetRW at remote home directory
            local remote_path = string.format("scp://%s@%s//home/%s/", user, host, user)
            vim.cmd("edit " .. remote_path)
          end)
        end)
        return true
      end,
    })
    :find()
end

-- Set the key binding
vim.keymap.set(
  "n",
  "<leader>sR",
  open_netrw_remote_home,
  { noremap = true, silent = true, desc = "Open NetRW at remote home" }
)
