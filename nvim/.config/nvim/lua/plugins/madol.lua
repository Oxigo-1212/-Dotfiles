return {
	"https://gitlab.com/repetitivesin/madol.nvim",
	dependencies = { "L3MON4D3/LuaSnip", "nvim-treesitter/nvim-treesitter" },
	config = function()
		local ls = require("luasnip")
		local function custom_latex_snippets(is_math)
			local autosnippet = ls.extend_decorator.apply(ls.snippet, {
				condition = is_math,
				snippetType = "autosnippet",
			})
			return {
				autosnippet("apx", ls.text_node("\\approx ")),
				autosnippet({ trig = ">~", wordTrig = false }, ls.text_node("\\gtrsim ")),
				autosnippet({ trig = "<~", wordTrig = false }, ls.text_node("\\lesssim ")),
			}
		end

		require("madol").setup({
			latex = {
				snippets = {
					["math-dollars"] = false,
					["math-brackets"] = true,
					["greek-tex"] = true,
					["greek-unicode"] = false,
					[custom_latex_snippets] = true,
				},
			},
		})
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
