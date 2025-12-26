return {
	{ "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "nvim-mini/mini.pick", version = "*" },
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
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		build = "make install_jsregexp",
	},
	{
		"https://gitlab.com/repetitivesin/madol.nvim",
		dependencies = { "L3MON4D3/LuaSnip", "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("madol").setup()
			local ls = require("luasnip")
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
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<C-S-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
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
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },

		version = "1.*",
		opts = {
			keymap = { preset = "default" },

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = { documentation = { auto_show = false } },

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
