local M = {}

function M.setup()
	-- Leader keys
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Compatibility fix for older Neovim versions (LSP fix)
	vim.lsp.get_clients = vim.lsp.get_clients or function(opts)
		if type(opts) == "table" and opts.bufnr then
			return vim.lsp.buf_get_clients(opts.bufnr)
		end
		return vim.lsp.buf_get_clients(0)
	end

	-- Enable true color
	vim.opt.termguicolors = true
end

return M
