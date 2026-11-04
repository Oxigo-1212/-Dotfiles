-- Custom lualine components, from craftzdog/dotfiles
-- (dot_config/nvim/lua/craftzdog/utils/lualine.lua), cut down to the options used here.

local M = {}

local root_markers = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

local function normalize(path)
	return (vim.uv.fs_realpath(path) or path):gsub("/$", "")
end

local function fg(group)
	local color = vim.api.nvim_get_hl(0, { name = group, link = false }).fg
	return color and ("#%06x"):format(color)
end

local function cwd()
	return normalize(vim.uv.cwd() or vim.fn.getcwd())
end

-- Searches upward from the current file for a root marker; falls back to cwd.
local function root()
	local path = vim.api.nvim_buf_get_name(0)
	path = path == "" and cwd() or vim.fs.dirname(path)
	local marker = vim.fs.find(root_markers, { path = path, upward = true })[1]
	return marker and normalize(vim.fs.dirname(marker)) or cwd()
end

-- Project root name, shown only when it differs from cwd.
M.root_dir = {
	function()
		return "󱉭  " .. vim.fs.basename(root())
	end,
	cond = function()
		return root() ~= cwd()
	end,
	color = function()
		return { fg = fg("Special") }
	end,
}

-- File path relative to cwd; the file name is bold, or highlighted when modified.
function M.pretty_path(self)
	local path = vim.fn.expand("%:p")
	if path == "" then
		return ""
	end
	path = normalize(path)
	local base = cwd()
	if path:find(base, 1, true) == 1 then
		path = path:sub(#base + 2)
	end
	local dir, file = path:match("^(.*/)([^/]*)$")
	dir, file = dir or "", file or path
	local section_hl = "%#lualine_" .. (self and self.options and self.options.section or "c") .. "_normal#"
	local file_hl = vim.bo.modified and "MatchParen" or "Bold"
	local result = dir .. "%#" .. file_hl .. "#" .. file .. section_hl
	if vim.bo.readonly or not vim.bo.modifiable then
		result = result .. " 󰌾 "
	end
	return result
end

-- Register a macro is being recorded into. Replaces the hidden command line's
-- "recording @q" message (cmdheight = 0).
M.macro_recording = {
	function()
		return "󰑋 " .. vim.fn.reg_recording()
	end,
	cond = function()
		return vim.fn.reg_recording() ~= ""
	end,
	color = function()
		return { fg = fg("DiagnosticError"), gui = "bold" }
	end,
}

return M
