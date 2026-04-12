function ColorMyPencils(color)
	color = color or "rose-pine-moon"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				disable_background = true,
				style = {
					italic = false,
				},
			})
		end,
	},
	{
		"bluz71/vim-nightfly-colors",
		name = "nightfly",
		lazy = false,
		priority = 1000,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
		},
	},
	{
		"CosecSecCot/midnight-desert.nvim",
		dependencies = {
			"rktjmp/lush.nvim",
		},
	},
	{
		"dasupradyumna/midnight.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = ...,
		config = function()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "gruvbox",
				callback = function()
					vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
					vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
					vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", fg = "#f5f5f5" })
					vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none", fg = "#888888" })
				end,
			})
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
	},
	{
		"webhooked/kanso.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			transparent_background = true,
		},
	},
	{
		"vague-theme/vague.nvim",
		lazy = false,  -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other plugins
		opts = {
			transparent = true,
		},
	},
	{
		"danfry1/lume",
		lazy = false,
		priority = 1000,
		config = function()
			require("lume").setup({
				transparent = true,
			})
		end,
	},
	{
		"shatur/neovim-ayu",
		lazy = false,
		priority = 1000,
		config = function()
			require("ayu").setup({
				mirage = true,
				overrides = {
					Normal = { bg = "None" },
					NormalFloat = { bg = "none" },
					ColorColumn = { bg = "None" },
					SignColumn = { bg = "None" },
					Folded = { bg = "None" },
					FoldColumn = { bg = "None" },
					CursorLine = { bg = "None" },
					CursorColumn = { bg = "None" },
					VertSplit = { bg = "None" },
				},
			})
		end,
	},
	{
		"Aejkatappaja/sora",
		config = function()
			require("sora").setup({
				transparent = true,
			})
		end,
	},
}
