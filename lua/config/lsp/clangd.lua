return {
	cmd = {
		'clangd',
		'--background-index',
		'--clang-tidy',
		'--header-insertion=never',
	},
	init_options = {
		fallbackStyle = 'Google',
		clangTidy = {
			enabled = true,
		}
	},
	settings = {
		clangd = {
			semanticHighlighting = true,
			completion = {
				includeHeader = true,
				placeholder = true,
			},
		}
	}
}
