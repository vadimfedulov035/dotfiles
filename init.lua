vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fix for older Neovim versions
vim.lsp.get_clients = vim.lsp.get_clients or function(opts)
  if type(opts) == "table" and opts.bufnr then
    return vim.lsp.buf_get_clients(opts.bufnr)
  end
  return vim.lsp.buf_get_clients(0) -- Default to current buffer
end

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins")

-- Set colorscheme with true colors
vim.opt.termguicolors = true
vim.cmd.colorscheme("nord")

vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#a3be8c" })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ebcb8b" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#bf616a" })

-- Configure diagnostics globally
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = '●',
  },
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = function(diagnostic)
      local icons = {
        Error = "",
        Warn = "",
        Info = "",
        Hint = "󰛨",
      }
      return icons[diagnostic.severity.name]
    end,
  },
})

-- Diagnostic keymaps (global, not LSP-specific)
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Hover diagnostics on CursorHold
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "CursorMoved", "InsertEnter" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})
