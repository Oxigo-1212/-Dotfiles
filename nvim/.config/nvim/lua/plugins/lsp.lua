return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = { } },
			"neovim/nvim-lspconfig",
		},
		opts = {
			servers = {
				copilot = { enabled = true },
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
								ignoreDir = { "xmake.lua" },
							},
							telemetry = {
								enable = false,
							},
						},
					},
				},
				basedpyright = { enabled = true },
				tsc = { enabled = true },
				zls = { enabled = true }
			}
		},
		config = function (_, opts)
			require("lsp")

			for server, config in pairs(opts.servers) do
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end
	},
	{ 'WhoIsSethDaniel/mason-tool-installer.nvim' },
	{
		"tarides/ocaml.nvim",
		config = function ()
			require("ocaml").setup()
		end
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			-- optional picker via telescope
			{ "nvim-telescope/telescope.nvim" },
			-- optional picker via fzf-lua
			{ "ibhagwan/fzf-lua" },
			-- .. or via snacks
			{
				"folke/snacks.nvim",
				opts = {
					terminal = { },
				}
			}
		},
		event = "LspAttach",
		opts = { },
	}
}
