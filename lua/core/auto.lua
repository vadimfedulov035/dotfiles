local M = {}

M.setup = function()
    -- Go formatting
    vim.api.nvim_create_augroup("GoFormat", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.go",
        group = "GoFormat",
        callback = function()
            local filename = vim.api.nvim_buf_get_name(0)
            if filename == "" then return end
            local cmd = "gofmt -w -s " .. vim.fn.shellescape(filename)
            os.execute(cmd)
            vim.cmd("e!")  -- Reload buffer
        end,
    })

    -- Python formatting with Ruff
    vim.api.nvim_create_augroup("PythonFormat", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.py",
        group = "PythonFormat",
        callback = function()
            local filename = vim.api.nvim_buf_get_name(0)
            if filename == "" then return end
            local cmd = "ruff check --fix " .. vim.fn.shellescape(filename)
            os.execute(cmd)
            vim.cmd("e!")  -- Reload buffer
        end,
    })
end

return M
