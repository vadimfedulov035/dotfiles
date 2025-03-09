local M = {}

local wk = require("which-key")

M.on_attach = function(_, bufnr)
	local tl = require("telescope.builtin")

	-- Register LSP keymaps with which-key
	wk.add({
		{ mode = "n", buffer = bufnr },

		-- Tree group
		{ "<leader>N", "<cmd>Neotree<CR>", desc = "Tree" },
		{ "<leader><ESC>", "<cmd>Neotree close<CR>", desc = "Close Tree" },

		-- Base group
		{ "<leader>K", vim.lsp.buf.hover, desc = "Documentation" },
		{ "<leader>R", vim.lsp.buf.rename, desc = "Rename" },

		-- Goto group
		{ "<leader>g", group = "Goto" },
		{ "<leader>gd", tl.lsp_definitions, desc = "Definition" },
		{ "<leader>gt", tl.lsp_type_definitions, desc = "Type Definition" },
		{ "<leader>gi", tl.lsp_implementations, desc = "Implementation" },
		{ "<leader>gr", tl.lsp_references, desc = "References" },

		-- Peek group
		{ "<leader>rn", vim.lsp.buf.rename, desc = "[R]e[n]ame" },
		{ "<leader>ca", vim.lsp.buf.code_action, desc = "[C]ode [A]ction" },
	})
end

-- Completion key mappings (passed separately)
M.get_cmp_mappings = function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	return {
		["<CR>"] = cmp.mapping.confirm({
			select = false,
			behavior = cmp.ConfirmBehavior.Insert,
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
