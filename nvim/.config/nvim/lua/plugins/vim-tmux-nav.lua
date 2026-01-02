return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	init = function()
		-- Disable default mappings (including terminal mode mappings)
		vim.g.tmux_navigator_no_mappings = 1
	end,
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
		"TmuxNavigatorProcessList",
	},
	config = function()
		-- Create mappings ONLY for normal mode
		vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<cr>", { silent = true })
		vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<cr>", { silent = true })
		vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<cr>", { silent = true })
		vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<cr>", { silent = true })

		-- Arrow key alternatives
		vim.keymap.set("n", "<C-Left>", ":TmuxNavigateLeft<cr>", { silent = true })
		vim.keymap.set("n", "<C-Down>", ":TmuxNavigateDown<cr>", { silent = true })
		vim.keymap.set("n", "<C-Up>", ":TmuxNavigateUp<cr>", { silent = true })
		vim.keymap.set("n", "<C-Right>", ":TmuxNavigateRight<cr>", { silent = true })
	end,
}
