local M = {}

function M.setup()
	require("core.options").setup()
	require("core.diagnostics").setup()
end

return M
