local M = {}

function M.setup()
	require('base16-colorscheme').setup({
		base00 = '#011423',
		base01 = '#061c2d',
		base02 = '#0b2538',
		base03 = '#3c6586',
		base04 = '#0fc5ed',
		base05 = '#cbe0f0',
		base06 = '#24eaf7',
		base07 = '#cbe0f0',
		base08 = '#e52e2e',
		base09 = '#a277ff',
		base0A = '#44ffb1',
		base0B = '#ffe073',
		base0C = '#24eaf7',
		base0D = '#0fc5ed',
		base0E = '#a277ff',
		base0F = '#a277ff',
	})

	local hi = function(group, opts)
		vim.api.nvim_set_hl(0, group, opts)
	end

	hi('Normal', { fg = '#cbe0f0', bg = '#011423' })
	hi('Comment', { fg = '#3c6586', italic = true })
	hi('Keyword', { fg = '#a277ff' })
	hi('Function', { fg = '#0fc5ed' })
	hi('Type', { fg = '#44ffb1' })
	hi('String', { fg = '#ffe073' })
	hi('Number', { fg = '#a277ff' })
	hi('Constant', { fg = '#a277ff' })
	hi('Identifier', { fg = '#24eaf7' })
	hi('TSConstant', { fg = '#a277ff' })
	hi('TSVariable', { fg = '#24eaf7' })

	-- telescope.nvim
	hi('TelescopeNormal', { fg = '#cbe0f0', bg = '#011423' })
	hi('TelescopeBorder', { fg = '#3c6586', bg = '#011423' })
	hi('TelescopePromptNormal', { fg = '#cbe0f0', bg = '#011423' })
	hi('TelescopePromptBorder', { fg = '#3c6586', bg = '#011423' })
	hi('TelescopePromptPrefix', { fg = '#a277ff', bg = '#011423' })
	hi('TelescopePromptCounter', { fg = '#0fc5ed', bg = '#011423' })
	hi('TelescopePromptTitle', { fg = '#a277ff', bg = '#ffe073' })
	hi('TelescopePreviewTitle', { fg = '#cbe0f0', bg = '#0fc5ed' })
	hi('TelescopeResultsTitle', { fg = '#44ffb1', bg = '#24eaf7' })
	hi('TelescopeSelection', { fg = '#cbe0f0', bg = '#0b2538' })
	hi('TelescopeSelectionCaret', { fg = '#a277ff', bg = '#0b2538' })
	hi('TelescopeMatching', { fg = '#0fc5ed', bold = true })

	-- mini.pick
	hi('MiniPickNormal', { fg = '#cbe0f0', bg = '#011423' })
	hi('MiniPickBorder', { fg = '#3c6586', bg = '#011423' })
	hi('MiniPickPrompt', { fg = '#cbe0f0', bg = '#011423' })
	hi('MiniPickPromptPrefix', { fg = '#a277ff', bg = '#011423' })
	hi('MiniPickBorderText', { fg = '#a277ff', bg = '#ffe073' })
	hi('MiniPickMatchCurrent', { fg = '#cbe0f0', bg = '#0b2538' })
	hi('MiniPickPromptCaret', { fg = '#a277ff', bg = '#0b2538' })
	hi('MiniPickMatchRanges', { fg = '#0fc5ed', bold = true })
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
