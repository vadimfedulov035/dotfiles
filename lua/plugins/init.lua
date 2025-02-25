local M = {}

function M.setup()
	local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			'git',
			'clone',
			'--filter=blob:none',
			'https://github.com/folke/lazy.nvim.git',
			'--branch=stable',
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)

	require('lazy').setup({
		{ import = 'plugins.lsp' },       -- Language Server Protocol
		{ import = 'plugins.ts' },        -- Tree Sitter
		{ import = 'plugins.wk' },        -- Which Key
		{ import = 'plugins.cmp' },       -- Complete
		{ import = 'plugins.telescope' }, -- Telescope
		{ import = 'plugins.git' },       -- Git
		{ import = 'plugins.tree' },      -- Tree
		{ import = 'plugins.colors' },
	})
end

return M
