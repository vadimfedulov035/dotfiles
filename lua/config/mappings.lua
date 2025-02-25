local M = {}

-- Core LSP on_attach
M.lsp_on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- LSP Actions
	vim.keymap.set("n", "K",  vim.lsp.buf.hover, { buffer = bufnr})

	-- Goto definitions
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = bufnr})
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer = bufnr})
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer = bufnr})

	-- Peek definitions
	vim.keymap.set("n", "pd", "<cmd>Lspsaga peek_definition<CR>", {buffer = bufnr})
	vim.keymap.set("n", "pt", "<cmd>Lspsaga peek_type_definition<CR>", {buffer = bufnr})
	vim.keymap.set("n", "pi", "<cmd>Lspsaga peek_implementation<CR>", {buffer = bufnr})
	-- Floating window management
	vim.keymap.set("n", "<Esc>", saga.action.close_all_floats, {buffer = bufnr})
end

--- EXTRA KEY MAPPINGS (import in module)
-- GitSigns key mappings
M.gitsigns_on_attach = function(_, bufnr)
	local gs = package.loaded.gitsigns

	vim.keymap.set("n", "]c", gs.next_hunk, "Next Hunk")
	vim.keymap.set("n", "[c", gs.prev_hunk, "Previous Hunk")
	vim.keymap.set("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
	vim.keymap.set("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
	vim.keymap.set("v", "<leader>hs", function() gs.stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end, "Stage Visual Hunk")
	vim.keymap.set("v", "<leader>hr", function() gs.reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end, "Reset Visual Hunk")
	vim.keymap.set("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
	vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage")
	vim.keymap.set("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
	vim.keymap.set("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
	vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
	vim.keymap.set("n", "<leader>hd", gs.diffthis, "Diff This")
	vim.keymap.set("n", "<leader>hD", function() gs.diffthis("~") end, "Diff Against HEAD~")
end

-- Completion key mappings
M.get_cmp_mappings = function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	return {
		["<CR>"] = cmp.mapping.confirm({
			select = false,
			behavior = cmp.ConfirmBehavior.Insert
		}),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-p>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}
end


return M
