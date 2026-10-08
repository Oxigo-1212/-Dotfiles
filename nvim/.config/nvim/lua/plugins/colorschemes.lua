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
		priority = 1000,
		config = function()
			local transparent = true -- set to true if you would like to enable transparency

			local coolnight = {
				bg = "#011323",
				bg_dark = "#00111E",
				bg_float = "#00111E",
				bg_highlight = "#012646",
				bg_popup = "#00111E",
				bg_search = "#3E90D7",
				bg_sidebar = "#00111E",
				bg_statusline = "#00111E",
				bg_visual = "#064984",
				fg = "#E3EEF7",
				fg_dark = "#AECBE5",
				fg_float = "#CBDFF0",
				fg_gutter = "#2D4F6C",
				fg_sidebar = "#AECBE5",
				border = "#03447C",
			}

			require("tokyonight").setup({
				style = "storm",
				transparent = transparent,
				styles = {
					sidebars = transparent and "transparent" or "dark",
					floats = transparent and "transparent" or "dark",
				},
				on_colors = function(colors)
					colors.bg = coolnight.bg
					colors.bg_dark = transparent and colors.none or coolnight.bg_dark
					colors.bg_float = transparent and colors.none or coolnight.bg_float
					colors.bg_highlight = coolnight.bg_highlight
					colors.bg_popup = coolnight.bg_popup
					colors.bg_search = coolnight.bg_search
					colors.bg_sidebar = transparent and colors.none or coolnight.bg_sidebar
					colors.bg_statusline = transparent and colors.none or coolnight.bg_statusline
					colors.bg_visual = coolnight.bg_visual
					colors.border = coolnight.border
					colors.fg = coolnight.fg
					colors.fg_dark = coolnight.fg_dark
					colors.fg_float = coolnight.fg_float
					colors.fg_gutter = coolnight.fg_gutter
					colors.fg_sidebar = coolnight.fg_sidebar
				end,
				lualine_bold = true,
			})

			vim.cmd("colorscheme tokyonight")
		end,
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
	"shaunsingh/nord.nvim",
	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.everforest_background = "soft"
			vim.g.everforest_transparent_background = 1
		end,
	},
	{
		"zenbones-theme/zenbones.nvim",
		-- Optionally install Lush. Allows for more configuration or extending the colorscheme
		-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
		-- In Vim, compat mode is turned on as Lush only works in Neovim.
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000,
		-- you can set set configuration options here
		-- config = function()
		--     vim.g.zenbones_darken_comments = 45
		--     vim.cmd.colorscheme('zenbones')
		-- end
	},
	-- lazy
	{
		"ray-x/aurora",
		init = function()
			vim.g.aurora_italic = 1
			vim.g.aurora_transparent = 1
			vim.g.aurora_bold = 1
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		config = function()
			require("nightfox").setup({
				options = {
					transparent = true,
				},
			})
		end,
	},
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
				styles = {
					sidebars = "dark",
					floats = "dark",
				},
			}
		end,
	},

}
