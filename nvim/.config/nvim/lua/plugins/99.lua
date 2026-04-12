return {
	"ThePrimeagen/99",
	config = function()
		-- workaround to override the OpenCode permissions
		vim.fn.setenv("OPENCODE_PERMISSION", '{"edit": "allow"}')

		local _99 = require("99")

		_99.setup({
			model = "github-copilot/gpt-5.4-mini",
			provider = _99.OpenCodeProvider,
			md_files = {
				"AGENTS.md",
			},
		})

		vim.keymap.set("v", "<leader>anp", function()
			_99.visual()
		end, { desc = "99 visual selection with prompt" })

		vim.keymap.set("n", "<leader>ans", function()
			_99.stop_all_requests()
		end, { desc = "99 stop all requests" })
	end,
}
