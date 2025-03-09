local M = {}

function M.setup()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)

	require("lazy").setup({
		{ import = "plugins.lsp" }, -- Language Server Protocol

		{ -- Nordic theme
			"AlexvZyl/nordic.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("nordic").setup({
					on_palette = function(palette)
						palette.gray4 = "#71797E"
					end,
					transparent = { bg = true, float = false },
				})
				require("nordic").load()
				local theme = require("config.theme")
				theme.apply_highlights()
			end,
		},

		{ -- TreeSitter
			"nvim-treesitter/nvim-treesitter",
			dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"vim",
						"vimdoc",
						"bash",
						"lua",
						"python",
						"go",
						"c",
						"rust",
						"zig",
						"markdown",
						"markdown_inline",
					},
					sync_install = false,
					auto_install = true,
					ignore_install = {},
					modules = {},
					highlight = {
						enable = false,
						additional_vim_regex_highlighting = false,
					},
					incremental_selection = { enable = true },
					indent = { enable = true },
					textobjects = { enable = true },
				})
			end,
		},

		{ -- WhichKey
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {},
			keys = {},
		},

		{ -- Telescope
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = { "nvim-lua/plenary.nvim" },
		},

		{ -- NeoTree
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
				"MunifTanjim/nui.nvim",
			},
		},

		{ -- GitSigns
			"lewis6991/gitsigns.nvim",
			event = "BufReadPre",
			config = function()
				local lsp = require("config.lsp")
				require("gitsigns").setup({
					signs = {
						add = { text = "▎" },
						change = { text = "▎" },
						delete = { text = "▎" },
						topdelete = { text = "▎" },
						changedelete = { text = "▎" },
						untracked = { text = "▎" },
					},
					signcolumn = true,
					numhl = false,
					linehl = false,
					word_diff = false,
					watch_gitdir = {
						interval = 1000,
						follow_files = true,
					},
					current_line_blame = false,
					current_line_blame_opts = {
						virt_text = true,
						virt_text_pos = "eol",
						delay = 300,
						ignore_whitespace = false,
						virt_text_priority = 100,
					},
				})
			end,
		},

		{ -- Autoformattting
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					"<leader>f",
					function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end,
					mode = "",
					desc = "[F]ormat buffer",
				},
			},
			opts = {
				notify_on_error = false,
				format_on_save = function(bufnr)
					local disable_filetypes = { c = true, cpp = true }
					local lsp_format_opt
					if disable_filetypes[vim.bo[bufnr].filetype] then
						lsp_format_opt = "never"
					else
						lsp_format_opt = "fallback"
					end
					return {
						timeout_ms = 500,
						lsp_format = lsp_format_opt,
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff check --fix" },
					golang = { "gofmt -w -s " },
				},
			},
		},

		{ -- Autocompletion
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp", -- LSP completion source
				"hrsh7th/cmp-buffer", -- Buffer words completion
				"hrsh7th/cmp-path", -- File paths completion
				"hrsh7th/cmp-cmdline", -- Command line completion
				"L3MON4D3/LuaSnip", -- Snippet engine
				"saadparwaiz1/cmp_luasnip", -- Snippet completion
				"rafamadriz/friendly-snippets", -- Snippet collections
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")

				-- Settings
				local theme = require("config.theme")
				local mappings = require("config.mappings")

				-- Load VS Code-like snippets
				require("luasnip.loaders.from_vscode").lazy_load()

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					mapping = mappings.get_cmp_mappings(),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" }, -- LSP completions
						{ name = "luasnip" }, -- Snippets
					}),
					window = {
						completion = {
							border = theme.border_style,
							winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:None",
							col_offset = -3,
							side_padding = 0,
						},
						documentation = { border = theme.border_style },
					},
					formatting = {
						fields = { "kind", "abbr", "menu" },
						format = function(_, item)
							item.kind = string.format("%s %s", theme.icons[item.kind], item.kind)
							return item
						end,
					},
				})
			end,
		},
	})
end

return M
