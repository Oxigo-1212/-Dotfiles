vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "xmake.lua",
	callback = function ()
		vim.lsp.start({
			name = "xmake_ls",
			cmd = { "xmake-language-server" },
			root_dir = vim.fs.root(0, { "xmake.lua", ".git" }),
		})
	end,
})
