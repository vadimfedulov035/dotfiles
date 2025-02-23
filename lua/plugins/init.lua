return {
  -- Mason.nvim - Package manager
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason LSP config
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "ruff", "gopls" },
        automatic_installation = true,
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "rmagatti/goto-preview",
      "hrsh7th/cmp-nvim-lsp",
      "ray-x/lsp_signature.nvim"
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require("lspconfig")
      local goto_preview = require("goto-preview")

      -- Common on_attach function
      local on_attach = function(client, bufnr)
	
        -- Essential for LSP-based completion
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Buffer-local mappings
        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- LSP Actions
        vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        -- Navigate back in jump list
        vim.keymap.set("n", "gb", "<C-o>", { 
          desc = "Jump back in navigation history" 
        })

	-- Completion Trigger
        vim.keymap.set("i", "<C-Space>", function()
          if cmp.visible() then
            cmp.abort()
          else
            cmp.complete()
          end
        end, { buffer = bufnr })

        -- Signature Help
        require "lsp_signature".on_attach({
          bind = true,
          handler_opts = {
            border = "rounded"
          }
        }, bufnr)
      end

      -- Python (ruff)
      lspconfig.ruff.setup({
        on_attach = on_attach,
        capabilities = capabilities,  -- Add this line
      })

      -- Go (gopls)
      lspconfig.gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities,  -- Add this line
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
      })
    end,
  },

  {
    "shaunsingh/nord.nvim",
    config = function()
      vim.g.nord_disable_background = true -- Add this line
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      require('nord').set()
    
      -- Add transparent highlights
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      --- Add string support
      vim.api.nvim_set_hl(0, "String", { italic = false })
    end,
  },

    -- NeoGit plugin
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- Required dependency
      "sindrets/diffview.nvim",         -- Optional but recommended
      "nvim-telescope/telescope.nvim",  -- For fuzzy finding in branches
    },
    config = function()
      local neogit = require("neogit")

      -- Basic setup with nord colors
      neogit.setup({
        disable_signs = false,
        disable_hint = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = true,
        kind = "split",  -- Open in split (options: split, tab, vsplit, auto)
        commit_popup = {
          kind = "split",
        },
        integrations = {
          diffview = true,  -- Use diffview.nvim for better diffs
        },
        -- Customize highlights for nord theme
        highlights = {
          -- Nord color scheme compatible
          italic = "Comment",
          bold = "Boolean",
          header = "Title",
          section_header = "Label",
        },
      })

      -- Key mappings
      vim.keymap.set("n", "<leader>gg", function()
        neogit.open({ kind = "split" })
      end, { desc = "Open NeoGit" })

      vim.keymap.set("n", "<leader>gc", function()
        neogit.open({ "commit" })
      end, { desc = "NeoGit Commit" })

      vim.keymap.set("n", "<leader>gd", function()
        neogit.open({ "diff" })
      end, { desc = "NeoGit Diff" })
    end
  },

  --- UI diagnostic
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({
        position = "bottom",
        height = 10,
        icons = true,
        use_diagnostic_signs = true,
      })
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
      vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>")
      vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>")
    end
  },


  -- Navigation
  {
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup({
        default_mappings = false,
        border = "rounded",
        resizing_mappings = false,
        focus_on_open = true,
        dismiss_on_move = false,
        force_close = true,
      })

      -- Preview
      vim.keymap.set("n", "pd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
      vim.keymap.set("n", "pt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>")
      vim.keymap.set("n", "pi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
      vim.keymap.set("n", "pr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>")
      vim.keymap.set("n", "<Esc>", "<cmd>lua require('goto-preview').close_all_win()<CR>", {
        noremap = true,
        silent = true
      })
    end
  },

    -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
          untracked    = { text = "▎" },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true
        },
        current_line_blame = true,  -- Show blame for current line
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 300,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },

        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Navigation
          vim.keymap.set("n", "]c", gs.next_hunk, { buffer = bufnr, desc = "Next Hunk" })
          vim.keymap.set("n", "[c", gs.prev_hunk, { buffer = bufnr, desc = "Prev Hunk" })

          -- Actions
          vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage Hunk" })
          vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset Hunk" })
          vim.keymap.set("v", "<leader>hs", function() gs.stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end,
            { buffer = bufnr, desc = "Stage Visual Hunk" })
          vim.keymap.set("v", "<leader>hr", function() gs.reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end,
            { buffer = bufnr, desc = "Reset Visual Hunk" })
          vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "Stage Buffer" })
          vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo Stage" })
          vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "Reset Buffer" })
          vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview Hunk" })
          vim.keymap.set("n", "<leader>hb", function() gs.blame_line({full=true}) end,
            { buffer = bufnr, desc = "Blame Line" })
          vim.keymap.set("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "Diff This" })
          vim.keymap.set("n", "<leader>hD", function() gs.diffthis("~") end,
            { buffer = bufnr, desc = "Diff Against HEAD~" })
        end
      })
    end
  },

  -- Auto-completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      luasnip.config.setup({})
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(_, vim_item)
            local icons = {
              Text = "",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "",
              Field = "󰇽",
              Variable = "󰂡",
              Class = "󰠱",
              Interface = "",
              Module = "",
              Property = "󰜢",
              Unit = "",
              Value = "󰎠",
              Enum = "",
              Keyword = "󰌋",
              Snippet = "",
              Color = "󰏘",
              File = "󰈙",
              Reference = "",
              Folder = "󰉋",
              EnumMember = "",
              Constant = "󰏿",
              Struct = "",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "󰅲",
            }
            vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
            return vim_item
          end
        },
      })
    end
  },

  -- LSP Enhancement
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup({
        hint_prefix = "󰛩 ",
        hi_parameter = "Visual",
        handler_opts = {
          border = "rounded"
        }
      })
    end
  },
}
