local M = {}

function M.setup()
	require("core.settings").setup()
	require("core.diagnostics").setup()
end

return M
