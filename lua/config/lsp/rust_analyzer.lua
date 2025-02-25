return {
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy",
				allTargets = true,
				extraArgs = { "--no-deps" },
			},
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
			},
			procMacro = { enable = true, },
			diagnostics = { enable = true, experimental = true, },
			inlayHints = {
				parameterNames = { enable = true },
				typeHints = { enable = true },
			},
			lens = { enable = true, references = true },
			semanticHighlighting = { operator = { enable = true } }
		}
	}
}
