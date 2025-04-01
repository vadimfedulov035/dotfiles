local M = {}

-- Severity to Canonical Name
local severity_num_to_name = {
	[vim.diagnostic.severity.ERROR] = "Error",
	[vim.diagnostic.severity.WARN] = "Warn",
	[vim.diagnostic.severity.INFO] = "Info",
	[vim.diagnostic.severity.HINT] = "Hint",
}

-- Canonical Name to Icon
local icons = {
	Error = "X ",
	Warn = "! ",
	Info = "i ",
	Hint = "? ",
}

-- Get the icon based on diagnostic severity
local function get_diagnostic_icon(diagnostic)
	local severity_name = severity_num_to_name[diagnostic.severity] or "Error" -- Fallback to "Error"
	return icons[severity_name] or "? "
end

function M.setup()
	-- Diagnostic configuration
	vim.diagnostic.config({
		virtual_text = {
			spacing = 4,
			severity_sort = true,
			source = "if_many",
			prefix = get_diagnostic_icon,
		},
		signs = false,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			border = "rounded",
			source = true,
			header = "",
			prefix = get_diagnostic_icon,
		},
	})

	-- Hover diagnostics autocommand (remains the same)
	vim.api.nvim_create_autocmd("CursorHold", {
		group = vim.api.nvim_create_augroup("UserDiagnosticHover", { clear = true }),
		pattern = "*",
		callback = function(args)
			local current_pos_diagnostics =
				vim.diagnostic.get(args.buf, { lnum = vim.fn.line(".") - 1, col = vim.fn.col(".") - 1 })
			if #current_pos_diagnostics > 0 then
				vim.diagnostic.open_float(nil, {
					focusable = false,
					close_events = { "CursorMoved", "CursorMovedI", "InsertEnter", "BufLeave" },
					border = "rounded",
					source = true,
					scope = "cursor",
				})
			end
		end,
		desc = "Show diagnostic float on hover",
	})
end

return M
