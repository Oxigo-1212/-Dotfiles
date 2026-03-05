return {
	"folke/snacks.nvim",
	opts = {
		styles = {
			-- INFO: show top right of screen
			snacks_image = {
				relative = "editor",
				col = -1,
			},
		},
		image = {
			doc = {
				inline = false,
				max_width = 200,
				max_height = 100,
			},
			math = {
				enabled = false,
				latex = {
					font_size = "small",
				}
			},
			formats = {
				"png",
				"jpg",
				"jpeg",
				"gif",
				"bmp",
				"webp",
				"tiff",
				"heic",
				"avif",
				"mp4",
				"mov",
				"avi",
				"mkv",
				"webm",
				"pdf",
				"icns",
			},
		}
	}
}
