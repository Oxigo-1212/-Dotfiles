-- Tabline from craftzdog/dotfiles (dot_config/nvim/lua/craftzdog/utils/tabline.lua).
-- Shown only with 2 or more tabs. Each tab is a trapezoid: the active window's
-- file name and icon, padded with 3 spaces, between slanted separators.
-- Colours come from the current colorscheme instead of solarized-osaka's palette.

local M = {}

local LEFT_SEP = "" -- nf-ple-lower_right_triangle (U+e0ba)
local RIGHT_SEP = "" -- nf-ple-lower_left_triangle (U+e0b8)
local MAX_NAME_LENGTH = 20
local TRUNCATE_TO = 17

local function hl(name)
	return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function set_highlights()
	local active_bg = hl("DiagnosticWarn").fg -- yellow in most themes
	local inactive_bg = hl("Visual").bg
	vim.api.nvim_set_hl(0, "TabLineActive", { fg = "#000000", bg = active_bg, bold = true })
	vim.api.nvim_set_hl(0, "TabLineInactive", { fg = hl("Normal").fg, bg = inactive_bg })
	vim.api.nvim_set_hl(0, "TabLineSepActive", { fg = active_bg, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TabLineSepInactive", { fg = inactive_bg, bg = "NONE" })
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
end

local function buf_info(bufnr)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if vim.bo[bufnr].buftype == "terminal" then
		return "[Terminal]", ""
	end
	if vim.bo[bufnr].filetype == "oil" then
		local dir = vim.fn.fnamemodify(bufname:gsub("^oil://", ""), ":~")
		if #dir > MAX_NAME_LENGTH then
			dir = "…" .. dir:sub(-TRUNCATE_TO)
		end
		return dir, ""
	end
	if bufname == "" then
		return "[No Name]", ""
	end
	local filename = vim.fn.fnamemodify(bufname, ":t")
	local icon = MiniIcons and MiniIcons.get("file", filename) or ""
	if #filename > MAX_NAME_LENGTH then
		filename = filename:sub(1, TRUNCATE_TO) .. "…"
	end
	return filename, icon
end

local function render_tab(tabnr, is_active)
	local bufnr = vim.fn.tabpagebuflist(tabnr)[vim.fn.tabpagewinnr(tabnr)]
	if not bufnr then
		return ""
	end
	local filename, icon = buf_info(bufnr)
	local modified = vim.bo[bufnr].modified and "[+] " or ""
	local title = "   " .. modified .. icon .. " " .. filename .. "   "
	local tab_hl = is_active and "%#TabLineActive#" or "%#TabLineInactive#"
	local sep_hl = is_active and "%#TabLineSepActive#" or "%#TabLineSepInactive#"
	-- %NT ... %T makes the tab clickable.
	return ("%%%dT%s%s%s%s%s%s%%T"):format(tabnr, sep_hl, LEFT_SEP, tab_hl, title, sep_hl, RIGHT_SEP)
end

function M.render()
	local ok, result = pcall(function()
		local parts = {}
		local current = vim.fn.tabpagenr()
		for tabnr = 1, vim.fn.tabpagenr("$") do
			parts[#parts + 1] = render_tab(tabnr, tabnr == current)
		end
		return table.concat(parts) .. "%#TabLineFill#"
	end)
	return ok and result or "%#TabLineFill#"
end

set_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })
vim.o.showtabline = 1 -- only when there are 2 or more tabs
vim.o.tabline = "%!v:lua.require('tabline').render()"

return M
