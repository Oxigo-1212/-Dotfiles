return {
	{ "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.0",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "nvim-mini/mini.pairs", version = "*" },
	{ "nvim-mini/mini.move", version = "*" },
	{
		"stevearc/oil.nvim",
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		lazy = false,
	},
	{ "nvim-lua/plenary.nvim" },
	{
		"vyfor/cord.nvim",
		build = ":Cord update",
		-- opts = {}
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"stevearc/quicker.nvim",
		ft = "qf",
	},
	{ "gbprod/yanky.nvim" },
	{ "mason-org/mason.nvim" },
	{ "mrcjkb/rustaceanvim", version = "^6", lazy = false },
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		build = "make install_jsregexp",
	},
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_compiler_latexmk_engines = {
				_ = "-xelatex",
			}
			vim.g.vimtex_view_method = "zathura"
		end,
	},
	{ "nvim-mini/mini.surround", version = "*" },
	{
		"saghen/blink.indent",
	},
	{
		"j-hui/fidget.nvim",
	},
	{
		"j-hui/fidget.nvim",
	},
}
