return {
	{
		"shaunsingh/nord.nvim",
		config = function()
			vim.g.nord_disable_background = true
			vim.g.nord_contrast = true
			vim.g.nord_borders = false
			require('nord').set()

			-- Add GitSign colors
			vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#a3be8c" })
			vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ebcb8b" })
			vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#bf616a" })
		end,
	},
}
