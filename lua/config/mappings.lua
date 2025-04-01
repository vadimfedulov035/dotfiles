local M = {}

-- Global mappings
function M.setup_global_mappings()
	local wk = require("which-key")
	wk.add({
		{ mode = "n" },

		-- Diagnostic Mappings
		{ "<leader>d", group = "Diagnostics" },
		{ "<leader>de", vim.diagnostic.open_float, desc = "Error Diagnostics" },
		{ "<leader>dl", vim.diagnostic.setloclist, desc = "List Diagnostics" },

		-- goto_prev/goto_next (wrapped in function)
		{
			"d[",
			function()
				vim.diagnostic.goto_prev({ wrap = false })
			end,
			desc = "Prev Diagnostic",
		},
		{
			"d]",
			function()
				vim.diagnostic.goto_next({ wrap = false })
			end,
			desc = "Next Diagnostic",
		},
	})
end

-- LSP mappings
M.on_attach = function(_, bufnr)
	local wk = require("which-key")
	wk.add({
		{ mode = "n", buffer = bufnr },

		-- Tree group
		{ "<leader>N", "<cmd>Neotree<CR>", desc = "Tree" },
		{ "<leader><ESC>", "<cmd>Neotree close<CR>", desc = "Close Tree" },

		-- LSP Base group
		{ "<leader>K", vim.lsp.buf.hover, desc = "Documentation" },
		{ "<leader>R", vim.lsp.buf.rename, desc = "Rename" },

		-- LSP Goto group
		{ "<leader>g", group = "Goto" },
		{ "<leader>gd", vim.lsp.buf.definition, desc = "Definition" },
		{ "<leader>gt", vim.lsp.buf.type_definition, desc = "Type Definition" },
		{ "<leader>gi", vim.lsp.buf.implementation, desc = "Implementation" },
		{ "<leader>gr", vim.lsp.buf.references, desc = "References (Quickfix)" },
		{ "<leader>gD", vim.lsp.buf.declaration, desc = "Declaration" },

		-- LSP Code Actions
		{ "<leader>ca", vim.lsp.buf.code_action, desc = "[C]ode [A]ction" },
	})
end

-- Completion mappings (passed in plugins)
M.get_cmp_mappings = function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	return {
		-- Confirm
		["<CR>"] = cmp.mapping.confirm({
			select = false,
			behavior = cmp.ConfirmBehavior.Insert,
		}),

		-- Complete
		["<C-Space>"] = cmp.mapping.complete(),

		-- Next
		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),

		-- Prev
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
