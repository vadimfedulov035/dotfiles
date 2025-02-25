local theme = require('config.theme')
local mappings = require('config.mappings')

return {
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',         -- LSP completion source
			'hrsh7th/cmp-buffer',           -- Buffer words completion
			'hrsh7th/cmp-path',             -- File paths completion
			'hrsh7th/cmp-cmdline',          -- Command line completion
			'L3MON4D3/LuaSnip',             -- Snippet engine
			'saadparwaiz1/cmp_luasnip',     -- Snippet completion
			'rafamadriz/friendly-snippets', -- Snippet collections
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')

			-- Load VS Code-like snippets
			require('luasnip.loaders.from_vscode').lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = mappings.get_cmp_mappings(),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },  -- LSP completions
					{ name = 'luasnip' },   -- Snippets
				}),
				window = {
					completion = {
						border = theme.border_style,
						winhighlight = 'Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpCursorLine',
						col_offset = -3,
						side_padding = 0,
					},
					documentation = { border = theme.border_style,
						winhighlight = 'Normal:CmpDocNormal,FloatBorder:CmpDocBorder', }
				},
				formatting = {
					fields = { 'kind', 'abbr', 'menu' },
					format = function(_, item)
						item.kind = string.format('%s %s', theme.icons[item.kind], item.kind)
						return item
					end
				}
			})
		end
	}
}
