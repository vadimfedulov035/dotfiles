local M = {}

function M.setup()
	-- Diagnostic configuration
	vim.diagnostic.config({
		virtual_text = {
			spacing = 4,
			prefix = "●",
		},
		float = {
			border = "rounded",
			source = "always",
			header = "",
			prefix = function(diagnostic)
				local icons = {
					Error = "?",
					Warn = "!",
					Info = "i",
					Hint = "n",
				}
				return icons[diagnostic.severity.name]
			end,
		},
	})

	-- Diagnostic keymaps
	local opts = { noremap = true, silent = true }
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

	-- Hover diagnostics
	vim.api.nvim_create_autocmd("CursorHold", {
		pattern = "*",
		callback = function()
			vim.diagnostic.open_float(nil, {
				focusable = false,
				close_events = { "CursorMoved", "InsertEnter" },
				border = "rounded",
				source = "always",
				prefix = " ",
			})
		end
	})
end

return M
