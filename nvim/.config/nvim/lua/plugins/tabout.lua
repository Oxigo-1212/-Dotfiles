return {
	{
		'abecodes/tabout.nvim',
		lazy = false,
		config = function ()
			require('tabout').setup {
				tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
				backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
				act_as_tab = true, -- shift content if tab out is not possible
				act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
				default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
				default_shift_tab = '<C-d>', -- reverse shift default action,
				enable_backwards = true, -- well ...
				completion = false, -- if the tabkey is used in a completion pum
				tabouts = {
					{ open = "'", close = "'" },
					{ open = '"', close = '"' },
					{ open = '`', close = '`' },
					{ open = '(', close = ')' },
					{ open = '[', close = ']' },
					{ open = '{', close = '}' }
				},
				ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
				exclude = { } -- tabout will ignore these filetypes
			}
			vim.keymap.set('i', '<Plug>(Tabout)', function()
				local tabout = require('tabout')
				local cursor = vim.api.nvim_win_get_cursor(0)
				local char = vim.api.nvim_get_current_line():sub(cursor[2] + 1, cursor[2] + 1)
				-- LaTeX treesitter does not group ordinary parentheses.
				if tabout.is_enabled() and (vim.bo.filetype == 'tex' or vim.bo.filetype == 'plaintex')
					and (char == ')' or char == ']' or char == '}') then
					vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + 1 })
				else
					tabout.tabout()
				end
			end, { silent = true })
		end,
		dependencies = { -- These are optional
			"nvim-treesitter/nvim-treesitter",
			"L3MON4D3/LuaSnip",
			"hrsh7th/nvim-cmp"
		},
		opt = true, -- Set this to true if the plugin is optional
		event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
		priority = 1000,
	},
	{
		"L3MON4D3/LuaSnip",
		keys = function ()
			-- Disable default tab keybinding in LuaSnip
			return { }
		end,
	},
}
