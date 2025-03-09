local M = {}

-- Nordic based on .Xresources
M.colors = {
	fg = "#D8DEE9",           -- *.foregroundColor
	border = "#81A1C1",       -- *.borderColor
	cursor = "#D8DEE9",       -- *.cursorColor
	selection_bg = "#2E3440", -- *.selectionBackgroundColor
	selection_fg = "#D8DEE9", -- *.selectionForegroundColor

	-- Normal colors
	black   = "#191D24",      -- color0
	red     = "#BF616A",      -- color1
	green   = "#A3BE8C",      -- color2
	yellow  = "#EBCB8B",      -- color3
	blue    = "#81A1C1",      -- color4
	magenta = "#B48EAD",      -- color5
	cyan    = "#8FBCBB",      -- color6
	white   = "#D8DEE9",      -- color7
	gray    = "#71797E",      -- color8
}

M.icons = {
	Text = " ",   Method = "󰆧 ",    Function = "󰊕 ", Constructor = " ",
	Field = "󰇽 ",  Variable = "󰂡 ",  Class = "󰠱 ",    Interface = " ",
	Module = " ", Property = "󰜢 ",  Unit = " ",     Value = "󰎠 ",
	Enum = " ",   Keyword = "󰌋 ",   Snippet = " ",  Color = "󰏘 ",
	File = "󰈙 ",   Reference = " ", Folder = "󰉋 ",   Constant = "󰏿 ",
	Struct = " ", Operator = "󰆕 "
}

function M.apply_highlights()
	local c = M.colors

	-- Common highlights
	vim.api.nvim_set_hl(0, 'Normal',      { bg = c.bg, fg = c.fg })
	vim.api.nvim_set_hl(0, 'FloatBorder', { fg = c.bright_blue, bg = c.bg })

	-- Completion menu (nvim-cmp)
	vim.api.nvim_set_hl(0, 'Pmenu',       { bg = c.black, fg = c.white })
	vim.api.nvim_set_hl(0, 'PmenuSel', {
		bg = c.selection_bg,
		fg = c.bright_yellow,
		bold = true
	})

	-- Diagnostic colors
	vim.api.nvim_set_hl(0, 'DiagnosticError',     { fg = c.bright_red })
	vim.api.nvim_set_hl(0, 'DiagnosticWarn',      { fg = c.bright_yellow })
	vim.api.nvim_set_hl(0, 'DiagnosticInfo',      { fg = c.bright_blue })
	vim.api.nvim_set_hl(0, 'DiagnosticHint',      { fg = c.bright_cyan })
end

M.border_style = "rounded"

return M
