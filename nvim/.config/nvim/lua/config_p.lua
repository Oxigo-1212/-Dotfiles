-- Settings for the plugins listed in lua/plugins.lua.

-- Globals read by plugin/ scripts. vim.pack sources those scripts after init.lua,
-- so setting the globals here is early enough.
vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
vim.g.vimtex_view_method = "sioyek"
vim.g.vimtex_quickfix_enabled = 0
vim.g.aurora_italic = 1
vim.g.aurora_transparent = 1
vim.g.aurora_bold = 1
vim.g.everforest_background = "soft"
vim.g.everforest_transparent_background = 1
vim.g.tmux_navigator_no_mappings = 1
vim.g.no_plugin_maps = true -- avoid conflicts with treesitter-textobjects

-- Colorschemes ---------------------------------------------------------------

require("rose-pine").setup({
	disable_background = true,
	styles = { italic = false },
})

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
	transparent = true,
	styles = { sidebars = "transparent", floats = "transparent" },
	on_colors = function(colors)
		for k, v in pairs(coolnight) do
			colors[k] = v
		end
		colors.bg_dark = colors.none
		colors.bg_float = colors.none
		colors.bg_sidebar = colors.none
		colors.bg_statusline = colors.none
	end,
	lualine_bold = true,
})

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

require("kanso").setup({ transparent = true })
require("catppuccin").setup({
	transparent_background = true,
	-- Snacks indent scope line: blue instead of the default grey-white overlay2.
	-- integrations = { snacks = { enabled = true, indent_scope_color = "blue" } },
})
require("vague").setup({ transparent = true })
require("lume").setup({ transparent = true })
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
require("sora").setup({ transparent = true })
require("nightfox").setup({ options = { transparent = true } })
require("solarized-osaka").setup({
	transparent = true,
	styles = { sidebars = "dark", floats = "dark" },
	on_highlights = function(hl, c)
		local prompt = "#2d3149"
		hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
		hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
		hl.TelescopePromptNormal = { bg = prompt }
		hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
		hl.TelescopePromptTitle = { bg = prompt, fg = prompt }
		hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
		hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
	end,
})

local ok, matugen = pcall(require, "matugen")
if ok then
	matugen.setup()
end

-- Treesitter -----------------------------------------------------------------

require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})
-- Runs asynchronously; does nothing for parsers already installed.
require("nvim-treesitter").install({
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"rust",
	"html",
	"latex",
})
-- Treesitter highlighting for every filetype that has a parser installed.
-- The pcall skips filetypes without one.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.stop)
	end,
})

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v",
			["@function.outer"] = "V",
			["@class.outer"] = "V",
		},
		include_surrounding_whitespace = false,
	},
})
for _, m in ipairs({
	{ "af", "@function.outer", "Select outer function" },
	{ "if", "@function.inner", "Select inner function" },
	{ "ac", "@class.outer",    "Select outer class" },
	{ "ic", "@class.inner",    "Select inner class" },
}) do
	vim.keymap.set({ "x", "o" }, m[1], function()
		require("nvim-treesitter-textobjects.select").select_textobject(m[2], "textobjects")
	end, { desc = m[3] })
end

require("treesj").setup()

-- LSP ------------------------------------------------------------------------

-- System tools (pacman/rustup) win; Mason only fills the gaps.
require("mason").setup({ PATH = "append" })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
				ignoreDir = { "xmake.lua" },
			},
			telemetry = { enable = false },
		},
	},
})
vim.lsp.enable("lua_ls")

require("ocaml").setup()
require("tiny-code-action").setup()
require("tiny-inline-diagnostic").setup({ preset = "minimal" })
vim.diagnostic.config({ virtual_text = false }) -- tiny-inline-diagnostic shows them instead
require("fidget").setup({
	notification = { window = { winblend = 0 } },
})

-- Completion and snippets ----------------------------------------------------

require("codeium").setup({
	enable_cmp_source = false,
	virtual_text = { enabled = false },
})

require("blink.cmp").setup({
	cmdline = {
		keymap = { preset = "inherit" },
		completion = { menu = { auto_show = true } },
	},
	keymap = {
		["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide", "fallback" },
		["<Tab>"] = { "accept", "fallback" },
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-up>"] = { "scroll_documentation_up", "fallback" },
		["<C-down>"] = { "scroll_documentation_down", "fallback" },
	},
	signature = { enabled = true, window = { border = "none" } },
	completion = {
		list = { selection = { preselect = false, auto_insert = true } },
		documentation = { auto_show = true, window = { border = "none" } },
		ghost_text = { enabled = false },
		menu = {
			auto_show = true,
			border = "none",
			draw = {
				treesitter = { "lsp" },
				columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
			},
		},
	},
	sources = {
		default = { "lsp", "path", "ripgrep", "codeium" },
		providers = {
			-- No buffer words, even when the LSP has nothing.
			lsp = { score_offset = 1000, fallbacks = {} },
			codeium = { name = "Codeium", module = "codeium.blink", score_offset = -100, async = true },
			ripgrep = { module = "blink-ripgrep", name = "Ripgrep", opts = {} },
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

local ls = require("luasnip")
ls.config.setup({
	enable_autosnippets = true,
	store_selection_keys = "<Tab>",
})
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
			["greek-tex"] = false,
			["greek-unicode"] = true,
			[custom_latex_snippets] = true,
		},
	},
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

require("tabout").setup({
	tabkey = "<Tab>",
	backwards_tabkey = "<S-Tab>",
	act_as_tab = true,
	act_as_shift_tab = false,
	default_tab = "<C-t>",
	default_shift_tab = "<C-d>",
	enable_backwards = true,
	completion = false,
	tabouts = {
		{ open = "'", close = "'" },
		{ open = '"', close = '"' },
		{ open = "`", close = "`" },
		{ open = "(", close = ")" },
		{ open = "[", close = "]" },
		{ open = "{", close = "}" },
	},
	ignore_beginning = true,
	exclude = {},
})
vim.keymap.set("i", "<Plug>(Tabout)", function()
	local tabout = require("tabout")
	local cursor = vim.api.nvim_win_get_cursor(0)
	local char = vim.api.nvim_get_current_line():sub(cursor[2] + 1, cursor[2] + 1)
	-- LaTeX treesitter does not group ordinary parentheses.
	if
			tabout.is_enabled()
			and (vim.bo.filetype == "tex" or vim.bo.filetype == "plaintex")
			and (char == ")" or char == "]" or char == "}")
	then
		vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + 1 })
	else
		tabout.tabout()
	end
end, { silent = true })

-- Telescope ------------------------------------------------------------------

local empty = ""
require("telescope").setup({
	defaults = {
		preview = { treesitter = true },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = { empty, empty, empty, empty, empty, empty, empty, empty },
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
	pickers = {
		find_files = { hidden = true },
	},
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("fidget")
require("telescope").load_extension("luasnip")

-- Git ------------------------------------------------------------------------

-- codediff settings from craftzdog/dotfiles (dot_config/nvim/lua/craftzdog/plugins/ui.lua).
-- Untracked files open with :edit in the diff window, which moves the cursor out
-- of the explorer. Put focus back where it was. Must run before setup(), because
-- codediff's views keep their own copy of this function.
-- ponytail: patches a codediff internal; remove if a codediff update fixes this.
local codediff_helpers = require("codediff.ui.view.helpers")
local open_real_file = codediff_helpers.open_real_file
codediff_helpers.open_real_file = function(win, target)
	local current = vim.api.nvim_get_current_win()
	local bufnr = open_real_file(win, target)
	if vim.api.nvim_win_is_valid(current) then
		vim.api.nvim_set_current_win(current)
	end
	return bufnr
end
require("codediff").setup({
	explorer = {
		width = 50,
		hidden = true, -- start closed; <leader>b in the diff view shows it
		untracked = "all", -- show untracked (??) files: "all", "normal" (collapse dirs) or "no"
		initial_focus = "modified", -- start in the diff, since the explorer is hidden
		auto_open_on_cursor = true, -- open the file under the cursor as you move
		view_mode = "tree",
		line_stats = { enabled = true }, -- +/- counts per file
	},
	diff = {
		layout = "inline", -- one pane with deleted lines shown inline; press t to switch to side-by-side
		compact = true, -- only changes plus context lines
		compact_context_lines = 8,
		compact_sync_folds = true, -- open/close folds in both panes together
	},
})

-- Editing and navigation -----------------------------------------------------

require("mini.icons").setup()
require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.ai").setup()
require("nvim-highlight-colors").setup()
require("quicker").setup()

require("oil").setup({
	default_file_explorer = true,
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	columns = { "icon", "permissions" },
	view_options = { show_hidden = false },
	win_options = {
		wrap = true,
		winbar = "%{v:lua.require('oil').get_current_dir()}",
	},
	use_default_keymaps = false,
	keymaps = {
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

for lhs, cmd in pairs({
	["<C-h>"] = "TmuxNavigateLeft",
	["<C-j>"] = "TmuxNavigateDown",
	["<C-k>"] = "TmuxNavigateUp",
	["<C-l>"] = "TmuxNavigateRight",
	["<C-Left>"] = "TmuxNavigateLeft",
	["<C-Down>"] = "TmuxNavigateDown",
	["<C-Up>"] = "TmuxNavigateUp",
	["<C-Right>"] = "TmuxNavigateRight",
}) do
	vim.keymap.set("n", lhs, "<cmd>" .. cmd .. "<cr>", { silent = true })
end

-- UI -------------------------------------------------------------------------

local parts = require("lualine_parts")
-- Statusline from craftzdog/dotfiles (dot_config/nvim/lua/craftzdog/plugins/ui.lua).
require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
		refresh = {
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
				"RecordingEnter", -- macro start
				"RecordingLeave", -- macro stop
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			parts.root_dir,
			{ "filetype",       icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ parts.pretty_path },
		},
		lualine_x = {
			parts.macro_recording,
			{ "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
			{ "diff",        symbols = { added = " ", modified = " ", removed = " " } },
		},
		lualine_y = { { "progress", separator = " ", padding = { left = 1, right = 1 } } },
		lualine_z = { { "location", padding = { left = 1, right = 1 } } },
	},
})

require("snacks").setup({
	-- From craftzdog/dotfiles (dot_config/nvim/lua/craftzdog/plugins/ui.lua).
	indent = { enabled = true },
	scroll = { enabled = false },
	picker = {
		enabled = true,
		sources = {
			files = { hidden = true },
			grep = { hidden = true },
		},
	},
	notifier = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	lazygit = {
		enabled = true,
		configure = true, -- sets the nvim-remote preset and syncs the theme
		theme = {
			activeBorderColor = { fg = "WarningMsg", bold = true },
		},
	},
	-- Your own settings.
	terminal = {},
	styles = {
		-- Show images at the top right of the screen.
		snacks_image = { relative = "editor", col = -1 },
	},
	image = {
		doc = { inline = false, max_width = 100, max_height = 50 },
		math = { enabled = false, latex = { font_size = "small" } },
		formats = {
			"png", "jpg", "jpeg", "gif", "bmp", "webp", "tiff", "heic", "avif",
			"mp4", "mov", "avi", "mkv", "webm", "pdf", "icns",
		},
	},
})
require("tiny-cmdline").setup({
	position = { y = "10%" }, -- default "50%"; lower = higher on screen
})
-- Transparent cmdline window: keep the border colour, drop the filled background.
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local border = vim.api.nvim_get_hl(0, { name = "FloatBorder", link = false })
		vim.api.nvim_set_hl(0, "TinyCmdlineNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "TinyCmdlineBorder", { fg = border.fg, bg = "none" })
	end,
})

-- Writing and notes ----------------------------------------------------------

require("render-markdown").setup({
	latex = { enabled = false, render_modes = { "n", "c", "t" } },
})
require("obsidian").setup({
	disable_frontmatter = false,
	workspaces = { { name = "Oxigo", path = "~/Documents/Oxigo/" } },
	ui = { enable = false },
})
require("img-clip").setup()
vim.keymap.set("n", "<leader>p", "<cmd>PasteImage<cr>", { desc = "Paste image from system clipboard" })
require("anki").setup({
	tex_support = false,
	models = {
		NoteType = "PathToDeck",
		["Basic"] = "Deck",
		["Super Basic"] = "Deck::ChildDeck",
	},
})

-- Other ----------------------------------------------------------------------

require("pair").setup({ backend = "claude" })
