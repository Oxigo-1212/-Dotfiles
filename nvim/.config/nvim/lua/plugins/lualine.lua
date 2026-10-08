return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		-- options = {
		-- 	theme = function()
		-- 		local theme = vim.deepcopy(require("lualine.themes.auto"))
		-- 		for _, sections in pairs(theme) do
		-- 			for section, highlight in pairs(sections) do
		-- 				highlight.gui = "NONE"
		-- 				if section == "a" then
		-- 					highlight.fg = "#071521"
		-- 				elseif section == "b" then
		-- 					highlight.fg = "#f1f5ff"
		-- 					highlight.bg = "#24445c"
		-- 				else
		-- 					highlight.fg = "#f1f5ff"
		-- 					highlight.bg = "#011323"
		-- 				end
		-- 			end
		-- 		end
		-- 		return theme
		-- 	end,
		globalstatus = true,
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			{
				"diagnostics",
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
			},
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ "filename", path = 1, symbols = { modified = " ", readonly = " ", unnamed = "[No Name]" } },
		},
		lualine_x = {
			{
				"diff",
				symbols = { added = " ", modified = " ", removed = " " },
			},
			"searchcount",
			{ "filetype", icons_enabled = false },
		},
		lualine_y = {
			{ "progress", separator = " ",                  padding = { left = 1, right = 0 } },
			{ "location", padding = { left = 0, right = 1 } },
		},
		lualine_z = {
			function()
				return " " .. os.date("%R")
			end,
		},
	},
	extensions = { "lazy", "trouble", "oil", "quickfix" },
}
