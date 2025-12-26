vim.cmd([[set noswapfile]])
vim.cmd([[hi @lsp.type.number gui=italic]])
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
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
require("keymaps")
require("autocmd")
require("compile")
require("layout")
require("mason").setup()
require("mini.surround").setup()
require("mini.pick").setup()
require("lualine").setup()
require("oil").setup({
	default_file_explorer = true,
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	columns = {
		"icon",
		"permissions",
		"mtime",
	},
	view_options = {
		show_hidden = true,
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
require("luasnip").config.setup({
	enable_autosnippets = true,
})
vim.cmd("colorscheme catppuccin")
vim.cmd(":hi statusline guibg=NONE")
