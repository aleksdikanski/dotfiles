local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}


return {
  {
    -- Language Server Protocol LSP
    -- enable LSP
    "neovim/nvim-lspconfig",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      capabilities = {
        textDocument = {
          completion = {
            snippedSupport = true
          }
        }
      },
      diagnostics = {
        underline = true,
        -- disable virtual text
        virtual_text = false,
        -- virtual_text = {
        --     spacing = 4,
        --     source = "if_many",
        --     prefix = "●",
        --     -- this will set set the prefix to a function that returns 
        --     -- the diagnostics icon based on the severity this only works
        --     -- on a recent 0.10.0 build. Will be set to "●" when not supported
        --     -- prefix = "icons",
        -- },

        -- show signs
        signs = {
          active = {
            { severity = "Error", name = "DiagnosticSignError", text = "" },
            { severity = "Warn", name = "DiagnosticSignWarn", text = "" },
            { severity = "Hint", name = "DiagnosticSignHint", text = "" },
            { severity = "Info", name = "DiagnosticSignInfo", text = "" },
          },
        },
        update_in_insert = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      },
      servers = {
        -- "jsonls",
        "pyright",
        "kotlin_language_server",
        "jdtls",
      },
      keymaps = function (bufnr)
        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap
        keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>zz", opts)
        keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>zz", opts)
        keymap(bufnr, "n", "K", "zz<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>zz", opts)
        keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>zz", opts)
        keymap(bufnr, "n", "gl", "zz<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
        keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
        keymap(bufnr, "n", "<leader>q", "<cmd>lu vim.diagnostic.setloclist()<CR>", opts)
      end,
    },
    config = function(_, opts)
      -- diagnostics signs / icons
      local signs = opts.diagnostics.signs.active

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- virtual text config
      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
          opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
            or function(diagnostic)
              for _, sign in pairs(signs) do
                if diagnostic.severity == vim.diagnostic.severity[sign.severity:upper()] then
                  return sign.text 
                end
              end
            end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- hover
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {
          border = "rounded",
        }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
          border = "rounded"
        }
      )

      local lspconfig = require "lspconfig"
      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local on_attach = function(client, bufnr)
        opts.keymaps(bufnr)

        if client.supports_method "textDocument/inlayHint" then
          vim.lsp.inlay_hint.enable(bufnr, true)
        end
      end

      for _, server in pairs(servers) do
        local opts = {
          on_attach = on_attach,
          capabilities = capabilities
        }

        local require_ok, settings = pcall(require, "user.lspsettings." .. server)
        if require_ok then
          opts = vim.tbl_deep_extend("force", settings, opts)
        end

        if server == "lua_ls" then
          require("neodev").setup {}
        end

        lspconfig[server].setup(opts)
      end
    end,
  },

  -- bridge between mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "pyright",
        -- "jsonls",
        "kotlin_language_server",
        "rust_analyzer",
        "sqlls",
      },
      automatic_installation = true,
    }
  },

  -- cmdline tools and lsp servers
  -- simple to use language server installer
  {
    "williamboman/mason.nvim",
    lazy = false,
    -- cmd = "Mason",
    -- keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ui = {
        -- help nvim_open_win()
        border = "rounded"
      }
    },
  },
}
