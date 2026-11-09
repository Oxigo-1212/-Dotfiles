-- Plugin list for the native plugin manager (:h vim.pack).
-- Settings live in lua/plugins_settings.lua.

local gh = function(repo)
	return "https://github.com/" .. repo
end

-- Build steps. This autocommand must exist before vim.pack.add() installs anything.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path
		if kind ~= "install" and kind ~= "update" then
			return
		end
		local run = function(cmd)
			vim.system(cmd, { cwd = path }):wait()
		end
		if name == "LuaSnip" then
			run({ "make", "install_jsregexp" })
		elseif name == "telescope-fzf-native.nvim" then
			run({ "sh", "-c",
				"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install" })
		elseif name == "nvim-treesitter" and kind == "update" then
			-- On install, plugins_settings.lua installs the parsers.
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	-- Shared libraries
	gh("nvim-lua/plenary.nvim"),
	gh("MunifTanjim/nui.nvim"),
	gh("nvim-tree/nvim-web-devicons"),
	{ src = gh("nvim-mini/mini.nvim"),        version = vim.version.range("*") },

	-- Colorschemes
	{ src = gh("rose-pine/neovim"),           name = "rose-pine" },
	{ src = gh("bluz71/vim-nightfly-colors"), name = "nightfly" },
	gh("folke/tokyonight.nvim"),
	gh("rktjmp/lush.nvim"),
	gh("CosecSecCot/midnight-desert.nvim"),
	gh("dasupradyumna/midnight.nvim"),
	gh("ellisonleao/gruvbox.nvim"),
	gh("rebelot/kanagawa.nvim"),
	gh("webhooked/kanso.nvim"),
	{ src = gh("catppuccin/nvim"),                             name = "catppuccin" },
	gh("vague-theme/vague.nvim"),
	gh("danfry1/lume"),
	gh("shatur/neovim-ayu"),
	gh("Aejkatappaja/sora"),
	gh("shaunsingh/nord.nvim"),
	gh("sainnhe/everforest"),
	gh("zenbones-theme/zenbones.nvim"),
	gh("ray-x/aurora"),
	gh("EdenEast/nightfox.nvim"),
	gh("craftzdog/solarized-osaka.nvim"),
	gh("RRethy/base16-nvim"),

	-- Treesitter
	{ src = gh("nvim-treesitter/nvim-treesitter"),             version = "main" },
	{ src = gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
	gh("Wansmer/treesj"),

	-- LSP
	gh("neovim/nvim-lspconfig"),
	gh("mason-org/mason.nvim"),
	gh("mason-org/mason-lspconfig.nvim"),
	gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
	gh("tarides/ocaml.nvim"),
	gh("rachartier/tiny-code-action.nvim"),
	gh("rachartier/tiny-inline-diagnostic.nvim"),
	gh("j-hui/fidget.nvim"),

	-- Completion and snippets
	{ src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2") },
	gh("rafamadriz/friendly-snippets"),
	gh("mikavilpas/blink-ripgrep.nvim"),
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1") },
	"https://gitlab.com/repetitivesin/madol.nvim",
	gh("abecodes/tabout.nvim"),

	-- Telescope
	{ src = gh("nvim-telescope/telescope.nvim"), version = "v0.2.0" },
	gh("nvim-telescope/telescope-fzf-native.nvim"),
	gh("benfowler/telescope-luasnip.nvim"),

	-- Git
	gh("esmuellert/codediff.nvim"), -- lazygit comes from snacks.nvim

	-- Editing and navigation
	gh("stevearc/oil.nvim"),
	gh("stevearc/quicker.nvim"),
	gh("gbprod/yanky.nvim"),
	gh("romainl/vim-cool"),
	gh("airblade/vim-rooter"),
	gh("christoomey/vim-tmux-navigator"),
	gh("brenoprata10/nvim-highlight-colors"),

	-- UI
	gh("nvim-lualine/lualine.nvim"),
	gh("folke/snacks.nvim"),
	gh("rachartier/tiny-cmdline.nvim"),

	-- Writing and notes
	gh("lervag/vimtex"),
	gh("MeanderingProgrammer/render-markdown.nvim"),
	{ src = gh("epwalsh/obsidian.nvim"),         version = vim.version.range("*") },
	gh("HakonHarnes/img-clip.nvim"),
	gh("brianhuster/live-preview.nvim"),
	gh("rareitems/anki.nvim"),

	-- Other
	gh("sampsn/pair.nvim"),
})
