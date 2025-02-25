local M = {}

local wk = require("which-key")

M.lsp_on_attach = function(_, bufnr)
    -- Register LSP keymaps with which-key
    wk.add({
        -- Hover documentation
	{ mode = "n", buffer = bufnr },
        { "<leader>N", "<cmd>Neotree<CR>", desc = "Tree"},
        { "<leader><ESC>", "<cmd>Neotree close<CR>", desc = "Close Tree"},
        { "<leader>K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover Documentation"},

        -- Goto group
        { "<leader>g", group = "Goto" },
        { "<leader>gd", vim.lsp.buf.definition, desc = "Definition"},
        { "<leader>gt", vim.lsp.buf.type_definition, desc = "Type Definition"},
        { "<leader>gi", vim.lsp.buf.implementation, desc = "Implementation"},

        -- Peek group
        { "<leader>p", group = "Peek" },
        { "<leader>pd", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek Definition"},
        { "<leader>pt", "<cmd>Lspsaga peek_type_definition<CR>", desc = "Peek Type Definition"},
        { "<leader>pi", "<cmd>Lspsaga peek_implementation<CR>", desc = "Peek Implementation"},
    })
end

M.git_on_attach = function(_, bufnr)
    local gs = package.loaded.gitsigns

    -- Register GitSigns keymaps with which-key
    wk.add({
	{mode = "n", buffer = bufnr },
        -- Navigation between hunks
        { "]c", gs.next_hunk, desc = "Next Hunk"},
        { "[c", gs.prev_hunk, desc = "Previous Hunk"},

        -- Hunk operations group
        { "<leader>h", group = "Hunk Operations" },
        { "<leader>hs", gs.stage_hunk,      desc = "Stage Hunk"},
        { "<leader>hr", gs.reset_hunk,      desc = "Reset Hunk"},
        { "<leader>hS", gs.stage_buffer,    desc = "Stage Buffer"},
        { "<leader>hu", gs.undo_stage_hunk, desc = "Undo Stage"},
        { "<leader>hR", gs.reset_buffer,    desc = "Reset Buffer"},
        { "<leader>hp", gs.preview_hunk,    desc = "Preview Hunk"},
        { "<leader>hb", function() gs.blame_line({ full = true }) end, desc = "Blame Line"},
        { "<leader>hd", gs.diffthis,        desc = "Diff This"},
        { "<leader>hD", function() gs.diffthis("~") end, desc = "Diff Against HEAD~"},

        -- Visual mode specific mappings
        { "<leader>hs", function()
              gs.stage_hunk({vim.fn.line("."), vim.fn.line("v")})
	end, desc = "Stage Visual Hunk", mode = "v", buffer = bufnr },
	{ "<leader>hr", function()
              gs.reset_hunk({vim.fn.line("."), vim.fn.line("v")})
          end, desc = "Reset Visual Hunk", mode = "v", buffer = bufnr },
    })
end

M.on_attach = function(_, bufnr)
	M.lsp_on_attach(_, bufnr)
	M.git_on_attach(_, bufnr)
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
