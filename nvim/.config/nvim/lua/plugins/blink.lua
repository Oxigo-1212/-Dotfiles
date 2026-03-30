return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets", "fang2hou/blink-copilot" },
	version = "1.*",
	opts = {
		cmdline = {
			keymap = { preset = "inherit" },
			completion = { menu = { auto_show = true } },
		},
		-- My super-TAB configuration
		keymap = {
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<Tab>"] = { "accept", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-up>"] = { "scroll_documentation_up", "fallback" },
			["<C-down>"] = { "scroll_documentation_down", "fallback" },
		},
		signature = { enabled = true, window = { border = "none" } },
		completion = {
			list = {
				selection = {
					preselect = false,
					auto_insert = true,
				}
			},
			documentation = { auto_show = true, window = { border = "none" } },
			ghost_text = { enabled = false },
			menu = {
				auto_show = true,
				border = "none",
				draw = {
					treesitter = { "lsp" },
					columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
				}
			}

		},
		sources = {
			default = function()
				local sources_list = { "lsp", "path", "snippets", "buffer" }
				if vim.g.copilot_enabled ~= false then
					table.insert(sources_list, "copilot")
				end
				return sources_list
			end,
			providers = {
				lsp = {
					score_offset = 1000,
				},
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = -100,
					async = true,
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
