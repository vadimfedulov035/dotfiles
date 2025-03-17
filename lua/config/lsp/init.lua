local M = {}

-- Auto-require all LSP server configurations
M.servers = {}

local function auto_require_servers()
	local servers_dir = vim.fn.stdpath("config") .. "/lua/config/lsp"
	for _, file in ipairs(vim.fn.readdir(servers_dir)) do
		if file:match("%.lua$") and file ~= "init.lua" then
			local server_name = file:gsub("%.lua$", "")
			M.servers[server_name] = require("config.lsp." .. server_name)
		end
	end
end
auto_require_servers()

-- Common base configuration
M.base_config = {
	on_attach = require("config.mappings").on_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

return M
