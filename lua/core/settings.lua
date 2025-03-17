local M = {}

function M.setup()
	-- Leader keys
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Sync with system clipboard (Ctrl+C/Ctrl+V)
	vim.schedule(function()
		vim.opt.clipboard = "unnamedplus"
	end)

	-- Compatibility fix for older Neovim versions (LSP fix)
	vim.lsp.get_clients = vim.lsp.get_clients
		or function(opts)
			if type(opts) == "table" and opts.bufnr then
				return vim.lsp.get_clients(opts.bufnr)
			end
			return vim.lsp.get_clients()
		end

	-- Highlight when yanking
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
		callback = function()
			vim.highlight.on_yank()
		end,
	})

	-- Case-insensetive searching UNLESS \C or mone or more capital letters
	vim.opt.ignorecase = true
	vim.opt.smartcase = true

	-- Enable true color
	vim.opt.termguicolors = true

	-- Enable line numbers
	vim.opt.number = true

	-- Tab configuration (4-width tabs by default)
	vim.opt.expandtab = false -- Use tabs by default
	vim.opt.tabstop = 4 -- Visual width of tabs
	vim.opt.shiftwidth = 4 -- Indentation width

	-- Python-specific spaces configuration
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "python",
		callback = function()
			vim.opt_local.expandtab = true -- Use spaces in Python
			vim.opt_local.tabstop = 4 -- 4-space wide tabs
			vim.opt_local.shiftwidth = 4 -- 4-space indentation
		end,
	})

	-- Line limit
	vim.opt.cc = "79"
	vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
		pattern = "*",
		callback = function()
			vim.fn.matchadd("Error", "\\%>79v.", -1)
		end,
	})
end

return M
