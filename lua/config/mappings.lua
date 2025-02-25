local M = {}

-- Helper function for buffer-local mappings
local create_map = function(bufnr)
	return function(mode, lhs, rhs, desc, opts)
		local options = vim.tbl_extend("force", {
			buffer = bufnr,
			noremap = true,
			silent = true,
			desc = desc,
		}, opts or {})

		vim.keymap.set(mode, lhs, rhs, options)
	end
end

-- Core LSP on_attach
M.lspcore_on_attach = function(client, bufnr)
	local map = create_map(bufnr)

	-- LSP Actions
	map("n", "K",  vim.lsp.buf.hover,       "Hover Documentation")
	map("n", "gd", vim.lsp.buf.definition,  "Goto Definition")
	map("n", "gr", vim.lsp.buf.references,  "Goto References")
	map("n", "rn", vim.lsp.buf.rename,      "Rename Symbol")
	map("n", "ca", vim.lsp.buf.code_action, "Code Actions")
	map("n", "f",  vim.lsp.buf.format,      "Format Buffer")

	-- Signature Help
	require("lsp_signature").on_attach({
		bind = true,
		handler_opts = {
			border = "rounded"
		}
	}, bufnr)
end

-- LSP Saga key mappings
M.lspsaga_on_attach = function(client, bufnr)
	local map = create_map(bufnr)
	local saga = require('lspsaga')

	-- Peek definitions
	map("n", "pd", saga.peek_definition, "Preview Definition")
	map("n", "pt", saga.peek_type_definition, "Preview Type Definition")
	-- Finder and implementations
	map("n", "pi", saga.lsp_finder, "Implementation Finder")
	map("n", "pr", saga.find_ref, "Find References")
	-- Code actions
	map({"n", "v"}, "<leader>ca", saga.code_action, "Code Action")
	-- Diagnostics
	map("n", "[e", saga.diagnostic.goto_prev, "Previous Diagnostic")
	map("n", "]e", saga.diagnostic.goto_next, "Next Diagnostic")
	-- Floating window management
	map("n", "<Esc>", saga.action.close_all_floats, "Close All Floats")
end

-- LSP key mappings
M.lsp_on_attach = function(client, bufnr)
	-- Set omnifunc for LSP-based completion
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	M.lspcore_on_attach(client, bufnr)
	M.lspsaga_on_attach(client, bufnr)
end

--- EXTRA KEY MAPPINGS (import in module)
-- GitSigns key mappings
M.gitsigns_on_attach = function(_, bufnr)
	local map = create_map(bufnr)
	local gs = package.loaded.gitsigns

	map("n", "]c", gs.next_hunk, "Next Hunk")
	map("n", "[c", gs.prev_hunk, "Previous Hunk")
	map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
	map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
	map("v", "<leader>hs", function() gs.stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end, "Stage Visual Hunk")
	map("v", "<leader>hr", function() gs.reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end, "Reset Visual Hunk")
	map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
	map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage")
	map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
	map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
	map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
	map("n", "<leader>hd", gs.diffthis, "Diff This")
	map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff Against HEAD~")
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
