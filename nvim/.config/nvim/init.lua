vim.cmd([[set noswapfile]])
vim.cmd([[hi @lsp.type.number gui=italic]])
vim.opt.backup = false
vim.o.cmdheight = 0
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
vim.opt.autochdir = false
vim.opt.wrap = false
vim.g.loaded_python3_provider = nil
vim.g.python3_host_prog = vim.fn.expand("~/.config/nvim/pyvenv/bin/python3")
vim.diagnostic.config({
	virtual_text = true,
	underline = true,
})
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- Floating cmdline and messages (:h ui2). Timeout and cmdline height moved to 'messagesopt'.
vim.opt.messagesopt:append({ "maxheight:50", "timeout:3000" })
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = {
			default = "msg", -- any kind not listed below
			empty = "cmd",
			bufwrite = "msg",
			confirm = "cmd",
			emsg = "pager",
			echo = "msg",
			echomsg = "msg",
			echoerr = "pager",
			completion = "cmd",
			list_cmd = "pager",
			lua_error = "pager",
			lua_print = "msg",
			progress = "pager",
			rpc_error = "pager",
			quickfix = "msg",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "msg",
			undo = "msg",
			verbose = "pager",
			wildlist = "cmd",
			wmsg = "msg",
			typed_cmd = "cmd",
		},
		dialog = { height = 0.5 },
		msg = { height = 0.3 },
		pager = { height = 0.5 },
	},
})
require("plugins")
require("config_p")

function ColorMyPencils(color)
	color = color or "rose-pine-moon"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- vim.o.statusline = "%{&fileformat}[%{&filetype}] %F%=%l/%L %l:%c %P"
-- ColorMyPencils("catppuccin-nvim")
-- vim.cmd.colorscheme("tokyonight")
--
vim.cmd("colorscheme catppuccin-nvim")
vim.api.nvim_set_hl(0, "Cursor", {
	bg = "NONE",
	fg = "NONE",
})
vim.opt.cursorline = false
vim.opt_local.cursorline = false
vim.cmd.packadd("nvim.undotree")
require("multigrep").setup()
require("lsp")
require("keymaps")
require("autocmd")
require("layout")
require("tabline")
-- local function project_root()
-- 	local root =
-- 			vim.fs.dirname(vim.fs.find({ ".git", "package.json", "Cargo.toml", "pyproject.toml" }, { upward = true })[1])
-- 	return root and vim.fs.basename(root) or vim.fs.basename(vim.fn.getcwd())
-- end
