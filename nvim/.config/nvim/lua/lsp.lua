-- Server binaries come from pacman/AUR; nvim-lspconfig provides the defaults.
-- To add a language: install the server, then add its name to vim.lsp.enable.

vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			-- Crucial for FAISS-cpu-git
			procMacro = { enable = true },
			cargo = {
				buildScripts = { enable = true },
				loadOutDirsFromCheck = true,
			},
			hover = {
				actions = { enable = true },
				documentation = { enable = true },
			},
			check = {
				command = "clippy",
				extraArgs = { "--no-deps" },
			},
			checkOnSave = true,
		},
	},
})

vim.lsp.config("kotlin_lsp", {
	single_file_support = false,
})

vim.lsp.enable({ "clangd", "ts_ls", "rust_analyzer", "kotlin_lsp", "pyright" })

-- xmake.lua is a Lua file, so only start xmake_ls for that file name.
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "xmake.lua",
	callback = function()
		vim.lsp.start({
			name = "xmake_ls",
			cmd = { "xmake-language-server" },
			root_dir = vim.fs.root(0, { "xmake.lua", ".git" }),
		})
	end,
})
