return {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
				path = vim.split(package.path, ';'),
			},
			diagnostics = {
				enable = true,
				globals = { 'vim' },     -- Add Neovim global variables
				unused = true,           -- Unused variables and parameters
				undefined = true,        -- Undefined variables
				shadow = true,           -- Variable shadowing
				unreachable = true,      -- Unreachable code
			},
			workspace = {
				checkThirdParty = false, -- Disable third party library checking
				library = vim.api.nvim_get_runtime_file('', true),
			},
			hint = {
				enable = true,
				paramType = true,        -- Show parameter type hints
				paramName = true,        -- Show parameter name hints
				arrayIndex = true,       -- Show array index hints
				setType = true,          -- Show type hints for sets
			},
			telemetry = { enable = false },  -- Disable telemetry
		}
	}
}


