return {
	"sampsn/pair.nvim",
	config = function()
		require("pair").setup({
			backend = "codex",
		})
	end,
}
