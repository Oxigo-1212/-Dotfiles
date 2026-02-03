return {
	{
		"benlubas/molten-nvim",
		build = ":UpdateRemotePlugins",
		dependencies = {
			{
				"3rd/image.nvim",
				opts = {
					backend = "kitty", -- WezTerm works best with ueberzugpp or its own integration
					-- Alternatively, try "kitty" as WezTerm supports a version of it,
					-- but "ueberzug" is often more stable for Neovim images in WezTerm.
					max_height_window_percentage = 50,
					hierarchical_path = true,
					integrations = {
						markdown = {
							enabled = true,
							clear_in_insert_mode = false,
							download_remote_images = false,
							only_render_image_at_cursor = false,
						},
					},
				},
			},
		},
		init = function()
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
			-- WezTerm specific: sometimes helps with rendering artifacts
			vim.g.molten_virt_text_output = true
		end,
	},
}
