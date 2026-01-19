return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			server = {
				copilot = { enabled = true },
			},
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{ 'WhoIsSethDaniel/mason-tool-installer.nvim' },
	{
		"tarides/ocaml.nvim",
		config = function()
			require("ocaml").setup()
		end
	}
}
