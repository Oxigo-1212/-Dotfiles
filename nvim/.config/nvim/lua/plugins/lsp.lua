return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
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
							},
							telemetry = {
								enable = false,
							},
						},
					},
				},
				basedpyright = { enabled = true },
				tsserver = { enabled = true },
				zls = { enabled = true }
			}
		},
		config = function(_, opts)
			for server, config in pairs(opts.servers) do
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end
	},
	{ 'WhoIsSethDaniel/mason-tool-installer.nvim' },
	{
		"tarides/ocaml.nvim",
		config = function()
			require("ocaml").setup()
		end
	}
}
