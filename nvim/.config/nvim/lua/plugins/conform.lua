return
{
	'stevearc/conform.nvim',
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff" },
				javascript = { "prettier", "prettierd" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				java = { "google-java-format" },
			},
			format_on_save = {
				lsp_fallback = true, -- This is the "magic" line
				timeout_ms = 500,
			},
		})
	end
}
