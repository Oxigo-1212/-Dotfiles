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
				-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
			}

			-- Required for `opts.events.reload`.
			vim.o.autoread = true

			-- OpenCode keybindings with <leader>o prefix
			vim.keymap.set({ "n", "x" }, "<leader>oa", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "OpenCode: Ask" })
			vim.keymap.set({ "n", "x" }, "<leader>ox", function()
				require("opencode").select()
			end, { desc = "OpenCode: Execute action" })
			vim.keymap.set({ "n", "x" }, "<leader>og", function()
				require("opencode").prompt("@this")
			end, { desc = "OpenCode: Add to prompt" })
			vim.keymap.set({ "n", "t" }, "<leader>ot", function()
				require("opencode").toggle()
			end, { desc = "OpenCode: Toggle panel" })
			vim.keymap.set("n", "<leader>ou", function()
				require("opencode").command("session.half.page.up")
			end, { desc = "OpenCode: Scroll up" })
			vim.keymap.set("n", "<leader>od", function()
				require("opencode").command("session.half.page.down")
			end, { desc = "OpenCode: Scroll down" })
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		opts = {
			suggestion = {
				enabled = not vim.g.ai_cmp,
				auto_trigger = true,
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
