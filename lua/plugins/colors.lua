return {
	{
		'AlexvZyl/nordic.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			require('nordic').setup({
				on_palette = function(palette)
					palette.gray4 = "#71797E"
				end,
				transparent = { bg = true, float = false, }
			})
			require('nordic').load()
		end
	}
}

