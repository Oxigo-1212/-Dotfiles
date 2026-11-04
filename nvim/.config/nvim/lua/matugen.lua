local M = {}

function M.setup()
	require('base16-colorscheme').setup({
		base00 = '#1d1b1d',
		base01 = '#211f22',
		base02 = '#262427',
		base03 = '#506696',
		base04 = '#4ea8de',
		base05 = '#e1e2d5',
		base06 = '#04a6c2',
		base07 = '#e1e2d5',
		base08 = '#d94a59',
		base09 = '#48bfe3',
		base0A = '#3dcc61',
		base0B = '#ffd400',
		base0C = '#04a6c2',
		base0D = '#4ea8de',
		base0E = '#5a189a',
		base0F = '#7b2cbf',
	})

	local hi = function(group, opts)
		vim.api.nvim_set_hl(0, group, opts)
	end

	hi('Normal', { fg = '#e1e2d5', bg = '#1d1b1d' })
	hi('Comment', { fg = '#506696', italic = true })
	hi('Keyword', { fg = '#5a189a' })
	hi('Function', { fg = '#4ea8de' })
	hi('Type', { fg = '#3dcc61' })
	hi('String', { fg = '#ffd400' })
	hi('Number', { fg = '#48bfe3' })
	hi('Constant', { fg = '#7b2cbf' })
	hi('Identifier', { fg = '#04a6c2' })
	hi('TSConstant', { fg = '#7b2cbf' })
	hi('TSVariable', { fg = '#04a6c2' })

	-- telescope.nvim
	hi('TelescopeNormal', { fg = '#e1e2d5', bg = '#1d1b1d' })
	hi('TelescopeBorder', { fg = '#506696', bg = '#1d1b1d' })
	hi('TelescopePromptNormal', { fg = '#e1e2d5', bg = '#1d1b1d' })
	hi('TelescopePromptBorder', { fg = '#506696', bg = '#1d1b1d' })
	hi('TelescopePromptPrefix', { fg = '#5a189a', bg = '#1d1b1d' })
	hi('TelescopePromptCounter', { fg = '#4ea8de', bg = '#1d1b1d' })
	hi('TelescopePromptTitle', { fg = '#5a189a', bg = '#ffd400' })
	hi('TelescopePreviewTitle', { fg = '#e1e2d5', bg = '#4ea8de' })
	hi('TelescopeResultsTitle', { fg = '#3dcc61', bg = '#04a6c2' })
	hi('TelescopeSelection', { fg = '#e1e2d5', bg = '#262427' })
	hi('TelescopeSelectionCaret', { fg = '#5a189a', bg = '#262427' })
	hi('TelescopeMatching', { fg = '#4ea8de', bold = true })

	-- mini.pick
	hi('MiniPickNormal', { fg = '#e1e2d5', bg = '#1d1b1d' })
	hi('MiniPickBorder', { fg = '#506696', bg = '#1d1b1d' })
	hi('MiniPickPrompt', { fg = '#e1e2d5', bg = '#1d1b1d' })
	hi('MiniPickPromptPrefix', { fg = '#5a189a', bg = '#1d1b1d' })
	hi('MiniPickBorderText', { fg = '#5a189a', bg = '#ffd400' })
	hi('MiniPickMatchCurrent', { fg = '#e1e2d5', bg = '#262427' })
	hi('MiniPickPromptCaret', { fg = '#5a189a', bg = '#262427' })
	hi('MiniPickMatchRanges', { fg = '#4ea8de', bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
	_G.__matugen_signal:stop()
	_G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
	'sigusr1',
	vim.schedule_wrap(function()
		package.loaded['matugen'] = nil
		require('matugen').setup()
	end)
)

return M
