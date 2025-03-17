return {
	{ -- Mason.nvim - Package manager
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{ -- Mason LSP config
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "ruff", "gopls" },
				automatic_installation = true,
			})
		end,
	},

	{ -- LSP config
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"ray-x/lsp_signature.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local lsp = require("config.lsp")

			for server_name, server_config in pairs(lsp.servers) do
				lspconfig[server_name].setup(vim.tbl_deep_extend("force", lsp.base_config, server_config))
			end
		end,
	},

	{ -- LSP Enhancement
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").setup({
				hint_prefix = "!",
				hi_parameter = "Visual",
				handler_opts = {
					border = "rounded",
				},
			})
		end,
	},
}
