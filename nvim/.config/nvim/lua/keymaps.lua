local builtin = require("telescope.builtin")
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<S-L>", ":bnext<CR>")
vim.keymap.set("n", "<S-H>", ":bprevious<CR>")
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP code action" })
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, { desc = "Rename all occurences" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "<leader>lf", builtin.lsp_document_symbols, { desc = "Find all function and method in a file" })
vim.keymap.set("n", "<leader>lb", builtin.diagnostics, { desc = "Find all diagnostics" })
vim.keymap.set("n", "<leader>lt", function()
	vim.keymap.set("n", "<leader>lo", builtin.lsp_workspace_symbols, { desc = "Find all objects in the workspace" })
	local is_enabled = vim.diagnostic.is_enabled()
	vim.diagnostic.enable(not is_enabled)
	vim.notify("Diagnostics " .. (is_enabled and "Disabled" or "Enabled"))
end, { desc = "Toggle LSP Diagnostics" })
vim.keymap.set("n", "<leader>wd", "<C-w>q", { desc = "Quit the window" })
vim.keymap.set("n", "<leader>|", ":vsplit<CR><C-w>l", { desc = "Vertical split and move" })
vim.keymap.set("n", "<leader>w|", ":vsplit<CR><C-w>l", { desc = "Vertical split and move" })
vim.keymap.set("n", "<leader>-", ":split<CR><C-w>j", { desc = "Horizontal split and move" })
vim.keymap.set("n", "<leader>w-", ":split<CR><C-w>j", { desc = "Horizontal split and move" })
vim.keymap.set("n", "<C-M-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-M-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-M-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-M-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<leader>bd", ":bdelete!<CR>", { desc = "Force delete buffer" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Open buffer navigation" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files in cwd" })
vim.keymap.set("n", "<leader>fc", builtin.colorscheme, { desc = "Change colorscheme" })
-- Bind <leader>fp to search your Neovim config files
vim.keymap.set("n", "<leader>fC", function()
	require("telescope.builtin").find_files({
		cwd = vim.fn.stdpath("config")
	})
end, { desc = "Find Private Config Files" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List open buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Find recently opened files" })

-- Minor remap from ThePrimeagen

vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ~/.config/tmux/scripts/tmux-sessionizer<CR>")

vim.keymap.set("n", "<space>t", function()
	-- Check if a terminal buffer already exists
	local term_buf = nil
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
			term_buf = buf
			break
		end
	end

	-- Check if terminal is already visible in a window
	if term_buf then
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(win) == term_buf then
				-- Terminal already visible, just focus it
				vim.api.nvim_set_current_win(win)
				return
			end
		end
		-- Terminal exists but not visible, open it in a new window
		vim.cmd.split()
		vim.api.nvim_win_set_buf(0, term_buf)
		vim.cmd.wincmd("J")
		vim.api.nvim_win_set_height(0, 10)
	else
		-- No terminal exists, create a new one
		vim.cmd.vnew()
		vim.cmd.term()
		vim.cmd.wincmd("J")
		vim.api.nvim_win_set_height(0, 10)
	end
end)
vim.keymap.set("t", "<C-l>", function()
	---@diagnostic disable-next-line: deprecated
	local chan = vim.api.nvim_buf_get_option(0, 'channel')
	if chan == 0 then
		vim.notify("No terminal channel found", vim.log.levels.WARN)
		return
	end
	vim.api.nvim_feedkeys("clear\r", "t", false)
end)
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<leader>w", function()
	local is_wrap_enabled = vim.wo.wrap
	vim.wo.wrap = not is_wrap_enabled
	vim.wo.linebreak = not is_wrap_enabled
	vim.notify("Line wrap " .. (is_wrap_enabled and "Disabled" or "Enabled"))
end, { desc = "Toggle line wrap" })

-- 1. Initialize (Just type <leader>mi then your kernel name)
vim.keymap.set("n", "<leader>mi", ":MoltenInit ", { desc = "Initialize Molten" })

-- 2. Run Code (Works for a single line in Normal mode or a selection in Visual mode)
vim.keymap.set("n", "<leader>mx", ":MoltenEvaluateLine<CR>", { desc = "Run line" })
vim.keymap.set("v", "<leader>mx", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Run selection" })

-- 3. Show/Enter Output (If you need to scroll through a table or error)
vim.keymap.set("n", "<leader>mo", ":MoltenEnterOutput<CR>", { desc = "Show output" })

-- 4. Delete/Clear (Get rid of the output when you're done)
vim.keymap.set("n", "<leader>mc", ":MoltenDelete<CR>", { desc = "Clear output" })
-- Interrupt the running kernel (Stop stuck code)
vim.keymap.set("n", "<leader>ms", ":MoltenInterrupt<CR>", { desc = "Stop/Interrupt kernel", silent = true })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
