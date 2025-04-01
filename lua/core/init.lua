local M = {}

function M.setup()
	require("core.settings").setup()
	require("core.diagnostic").setup()
end

return M
