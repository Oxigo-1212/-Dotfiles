return {
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			-- Recommended for `ask()` and `select()`.
			-- Required for `snacks` provider.
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			vim.g.opencode_opts = {
				provider = {
					enabled = "tmux",
					cmd = "env TERM=xterm-256color opencode --port",
					tmux = {},
				},
			}
			-- Required for `opts.events.reload`.
			vim.o.autoread = true

			-- OpenCode keybindings with <leader>o prefix
			vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end,
				{ desc = "Ask opencode…" })
			vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end,
				{ desc = "Execute opencode action…" })
			vim.keymap.set({ "n", "t" }, "<leader>ot", function() require("opencode").toggle() end,
				{ desc = "Toggle opencode" })
			vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
				{ desc = "Add range to opencode", expr = true })
			vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
				{ desc = "Add line to opencode", expr = true })

			vim.keymap.set("n", "<leader>ou", function() require("opencode").command("session.half.page.up") end,
				{ desc = "Scroll opencode up" })
			vim.keymap.set("n", "<leader>od", function() require("opencode").command("session.half.page.down") end,
				{ desc = "Scroll opencode down" })
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		opts = {
			suggestion = {
				enabled = false,
				auto_trigger = false,
				hide_during_completion = vim.g.ai_cmp,
				keymap = {
					accept = false, -- handled by nvim-cmp / blink.cmp
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},
}
