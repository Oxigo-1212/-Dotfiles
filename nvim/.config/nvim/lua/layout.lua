local is_linux = vim.uv.os_uname().sysname == "Linux"
if is_linux then
	local default_layout = "keyboard-us"
	local last_layout = default_layout
	local function get_current_layout()
		local handle = io.popen("fcitx5-remote -n")
		local layout
		if handle ~= nil then
			layout = handle:read("*all"):gsub("%s+", "")
			handle:close()
		end
		return layout
	end

	local function set_layout(layout)
		os.execute("fcitx5-remote -s " .. layout)
	end

	vim.api.nvim_create_autocmd({ "InsertLeave" }, {
		callback = function()
			local current_layout = get_current_layout()
			last_layout = current_layout
			set_layout(default_layout)
		end,
	})
	vim.api.nvim_create_autocmd({ "InsertEnter" }, {
		callback = function()
			set_layout(last_layout)
		end,
	})
	vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
		pattern = "*:*n",
		callback = function()
			set_layout(default_layout)
		end,
	})
	vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
		pattern = "*:*n",
		callback = function()
			set_layout(default_layout)
		end,
	})
	vim.api.nvim_create_autocmd({ "FocusGained" }, {
		callback = function()
			if vim.fn.mode() == "i" then
				set_layout(last_layout)
			else
				set_layout(default_layout)
			end
		end,
	})
end
