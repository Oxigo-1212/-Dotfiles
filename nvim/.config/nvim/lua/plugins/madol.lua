return {
	"https://gitlab.com/repetitivesin/madol.nvim",
	dependencies = { "L3MON4D3/LuaSnip", "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("madol").setup()
		local ls = require("luasnip")
		ls.config.setup({
			enable_autosnippets = true,
			store_selection_keys = "<Tab>",
		})
		vim.keymap.set({ "s", "i" }, "<C-j>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			else
				return "<C-j>"
			end
		end, { silent = true })
		vim.keymap.set({ "s", "i" }, "<C-k>", function()
			if ls.choice_active() then
				ls.change_choice(-1)
			else
				return "<C-k>"
			end
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
			ls.jump(-1)
		end, { silent = true })
	end,
}
