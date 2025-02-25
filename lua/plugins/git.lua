return {
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			local lsp = require("config.lsp")
			require("gitsigns").setup({
				signs = {
					add          = { text = "▎" },
					change       = { text = "▎" },
					delete       = { text = "▎" },
					topdelete    = { text = "▎" },
					changedelete = { text = "▎" },
					untracked    = { text = "▎" },
				},
				signcolumn = true,
				numhl = false,
				linehl = false,
				word_diff = false,
				watch_gitdir = {
					interval = 1000,
					follow_files = true
				},
				current_line_blame = false,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					delay = 300,
					ignore_whitespace = false,
					virt_text_priority = 100,
				},
				on_attach = lsp.gitsigns_on_attach,
			})
		end
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",         -- Required dependency
			"sindrets/diffview.nvim",        -- Optional but recommended
			"nvim-telescope/telescope.nvim", -- For fuzzy finding in branches
		},
		config = function()
			local neogit = require("neogit")

			-- Basic setup with nord colors
			neogit.setup({
				disable_signs = false,
				disable_hint = false,
				disable_context_highlighting = false,
				disable_commit_confirmation = true,
				kind = "split",  -- Open in split (options: split, tab, vsplit, auto)
				commit_popup = {
					kind = "split",
				},
				integrations = {
					diffview = true,  -- Use diffview.nvim for better diffs
				},
				-- Customize highlights for nord theme
				highlights = {
					-- Nord color scheme compatible
					italic = "Comment",
					bold = "Boolean",
					header = "Title",
					section_header = "Label",
				},
			})
		end
	}
}
