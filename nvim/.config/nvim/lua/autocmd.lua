vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("LspFormatting", {}),
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

local function save_cwd()
	local cwd = vim.fn.getcwd()
	-- Use a PID-specific file if provided by the shell, otherwise fallback
	local shell_pid = os.getenv("NVIM_SHELL_PID") or "global"
	local file_path = os.getenv("HOME") .. "/.nvim_last_dir_" .. shell_pid

	local file = io.open(file_path, "w")
	if file then
		file:write(cwd)
		file:close()
	end
end

-- Your existing triggers
vim.api.nvim_create_autocmd({ "DirChanged", "VimLeavePre" }, {
	callback = save_cwd,
})

-- Keep your OSC7 logic for WezTerm UI features (Tabs/Panes)
local function update_osc7()
	local cwd = vim.fn.getcwd()
	local uri = "file://" .. vim.fn.hostname() .. cwd
	io.stdout:write("\27]7;" .. uri .. "\27\\")
end

vim.api.nvim_create_autocmd("DirChanged", { callback = update_osc7 })
update_osc7()
save_cwd()
