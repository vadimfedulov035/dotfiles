return {
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = {
					'vim', 'vimdoc','bash',
					'lua', 'python', 'go',
					'c', 'rust', 'zig',
					'markdown', 'markdown_inline'
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = false,
					additional_vim_regex_highlighting = false,
				},
				incremental_selection = { enable = true },
				indent = { enable = true },
				textobjects = { enable = true },
			})
		end
	}
}
