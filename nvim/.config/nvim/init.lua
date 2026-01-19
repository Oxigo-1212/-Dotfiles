vim.cmd([[set noswapfile]])
vim.cmd([[hi @lsp.type.number gui=italic]])
vim.opt.backup = false
vim.opt.fillchars = { eob = " " }
vim.opt.startofline = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autochdir = true
vim.opt.wrap = false
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = true },
})
-- vim.o.statusline = "%{&fileformat}[%{&filetype}] %F%=%l/%L %l:%c %P"
-- vim.api.nvim_set_hl(0, "StatusLine", { fg = "#C5C9C7", bg = "NONE" })
-- vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#A4A7A4", bg = "NONE" })
vim.cmd("colorscheme rose-pine")
vim.cmd(":hi statusline guibg=NONE")
require("multigrep").setup()
require("nvim-highlight-colors").setup()
require("fidget").setup({
	notification = {
		window = {
			winblend = 0,
		},
	},
})
require("keymaps")
require("autocmd")
require("layout")
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
			refresh_time = 16, -- ~60fps
			events = {
				'WinEnter',
				'BufEnter',
				'BufWritePost',
				'SessionLoadPost',
				'FileChangedShellPost',
				'VimResized',
				'Filetype',
				'CursorMoved',
				'CursorMovedI',
				'ModeChanged',
			},
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
})
require("mason").setup()
require("mini.surround").setup()
require("mini.pairs").setup()
require("kanso").setup({
	transparent = true,
})
require("oil").setup({
	default_file_explorer = true,
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	columns = {
		"icon",
		"permissions",
	},
	view_options = {
		show_hidden = false,
	},
	win_options = {
		wrap = true,
		winbar = "%{v:lua.require('oil').get_current_dir()}",
	},
	use_default_keymaps = false,
	keymaps = {
		-- Press 'yp' (yank path) to copy the current directory to your clipboard
		["yp"] = {
			desc = "Copy current directory path",
			callback = function()
				local dir = require("oil").get_current_dir()
				vim.fn.setreg("+", dir)
				print("Copied: " .. dir)
			end,
		},
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-t>"] = { "actions.select", opts = { tab = true } },
		["<C-p>"] = "actions.preview",
		["<C-c>"] = { "actions.close", mode = "n" },
		["gr"] = "actions.refresh",
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["`"] = { "actions.cd", mode = "n" },
		["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
	},
})
require("madol").setup({
	latex = {
		snippets = {
			["math-dollars"] = false,
			["math-brackets"] = true,
			["greek-tex"] = false,
			["greek-unicode"] = true,
		},
	},
})
require("telescope").setup({
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
	pickers = {
		find_files = {
			hidden = true,
			theme = "ivy"
		},
		buffers = {
			initial_mode = "normal",
			theme = "ivy"
		},
		find_files = {
			initial_mode = "normal",
			theme = "ivy"
		},
		diagnostics = {
			initial_mode = "normal",
			theme = "ivy"
		},
		colorscheme = {
			initial_mode = "normal",
			theme = "ivy"
		},
	},
})
require("telescope").load_extension("fzf")
require("telescope.builtin").lsp_workspace_symbols({
	symbols = { "class", "function", "method" },
})
require("telescope").load_extension("fidget")
require("luasnip").config.setup({
	enable_autosnippets = true,
})
