return {
	-- Main nvim-treesitter plugin
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- Install parsers (runs asynchronously, no-op if already installed)
			require("nvim-treesitter").install({
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"rust",
				"html",
				"latex",
			})

			-- Enable highlighting and indentation globally for all filetypes
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function()
					-- Enable treesitter highlighting and other features
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},

	-- Treesitter textobjects plugin
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		init = function()
			-- Disable built-in ftplugin mappings to avoid conflicts
			vim.g.no_plugin_maps = true
		end,
		config = function()
			-- Configure textobjects
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					-- Selection modes (default is charwise 'v')
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "V", -- linewise
					},
					-- Don't include surrounding whitespace
					include_surrounding_whitespace = false,
				},
			})

			-- Setup textobject keymaps
			-- Function textobjects
			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end, { desc = "Select outer function" })

			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end, { desc = "Select inner function" })

			-- Class textobjects
			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end, { desc = "Select outer class" })

			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end, { desc = "Select inner class" })
		end,
	},
}
