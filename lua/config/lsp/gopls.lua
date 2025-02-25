return {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true, -- Unused function parameters (you already have this)
        unusedvariable = true,  -- Unused local variables
        unreachable = true,  -- Unreachable code (e.g., after return)
        nilness = true,  -- Potential nil pointer dereferences
        shadow = true,  -- Shadowed variables (accidental variable reuse)
        unusedwrite = true,  -- Unused variable writes (e.g., reassigned before read)
        useany = true,  -- Discourages `interface{}` where possible
        ST1003 = true,  -- Enforces idiomatic error naming (e.g., `errFoo`, not `fooError`)
	simplifycompositelit = true, -- Suggests simplified composite literals (e.g., `[]int{1, 2}` → `[]int{1, 2}`)
	simplifyrange = true,    -- Simplifies redundant `range` loops
        httpresponse = true,  -- Checks for unclosed HTTP response bodies
	undeferredclose = true,   -- Checks for resources closed without `defer` where appropriate
      },
	hints = {
		assignVariableTypes = true,  -- Shows inferred types for variables
		compositeLiteralFields = true, -- Shows field names in struct literals
		constantValues = true,      -- Shows values for constants on hover
		functionTypeParameters = true, -- Shows generic type parameters
	},
	codelenses = {
		gc_details = true,    -- Adds code lens to show GC optimization details
		test = true,          -- Adds "run test" code lenses
		generate = true,      -- Adds "go:generate" code lenses
	},
	completeUnimported = true,  -- Auto-suggest imports for unimported packages
	semanticTokens = false,     -- Enables semantic highlighting (colorizes symbols semantically)
    },
  },				
}
