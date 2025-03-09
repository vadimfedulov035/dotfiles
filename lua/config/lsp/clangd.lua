return {
	cmd = {
		'clangd',
		'--background-index',
		'--clang-tidy',
		'--header-insertion=never',
		'--tweaks=-std=c23',
		'--tweaks=-Wno-cpp',
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
