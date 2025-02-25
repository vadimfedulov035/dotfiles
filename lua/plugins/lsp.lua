local theme = require('config.theme')

return {
	-- Mason.nvim - Package manager
	{
		'williamboman/mason.nvim',
		config = function()
			require('mason').setup()
		end,
	},

	-- Mason LSP config
	{
		'williamboman/mason-lspconfig.nvim',
		dependencies = { 'williamboman/mason.nvim' },
		config = function()
			require('mason-lspconfig').setup({
				ensure_installed = { 'ruff', 'gopls' },
				automatic_installation = true,
			})
		end,
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason-lspconfig.nvim',
			'hrsh7th/cmp-nvim-lsp',
			'ray-x/lsp_signature.nvim'
		},
		config = function()
			local lspconfig = require('lspconfig')
			local lsp = require('config.lsp')
			-- Configure all servers
			for server_name, server_config in pairs(lsp.servers) do
				lspconfig[server_name].setup(vim.tbl_deep_extend(
				'force',
				lsp.base_config,
				server_config
				))
			end
		end
	},
	{
		'nvimdev/lspsaga.nvim',
		dependencies = {
			'nvim-tree/nvim-web-devicons'
		},
		config = function()
			require('lspsaga').setup({
				ui = {
					border = theme.border_style,
					colors = {
						normal_bg = theme.colors.bg,
						title_bg = theme.colors.blue,
						float_bg = theme.colors.bg,
					},
					kind_icons = theme.icons
				},
				hover = {
					border = theme.border_style,
					max_width = 80
				},
				definition = {
					border = theme.border_style,
				},
				code_action = {
					border = theme.border_style,
				},
				lightbulb = {
					sign = false,
					virtual_text = false,
				},
			})
		end
	},
	-- LSP Enhancement
	{
		'ray-x/lsp_signature.nvim',
		config = function()
			require('lsp_signature').setup({
				hint_prefix = '!',
				hi_parameter = 'Visual',
				handler_opts = {
					border = 'rounded'
				}
			})
		end
	}
}
