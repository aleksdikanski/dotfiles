return {
  { "folke/lazy.nvim", version = "*" },
  { import = "user.plugins" },
  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },

  -- Snippets --
  -- snippet engine
  { "L3MON4D3/LuaSnip" },
  -- a bunch of snippets to use
  { "rafamadriz/friendly-snippets" },

  -- simple to use language server installer
  { "williamboman/mason-lspconfig.nvim" },
  -- LSP diagnostics and code actions
  { 
    "nvimtools/none-ls.nvim",
    opts = function()
      local null_ls = require("null-ls")

      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      local formatting = null_ls.builtins.formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      local diagnostics = null_ls.builtins.diagnostics
      
      local code_actions = null_ls.builtins.code_actions

      return {
        debug = false,
        sources = {
          formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
          formatting.black.with({ extra_args = { "--fast" } }),
          formatting.stylua,
          formatting.ktlint,
          code_actions.gitsigns,
          -- diagnostics.flake8
          diagnostics.cfn_lint,
          diagnostics.ktlint,
        },
      }
    end
  },

  -- Linting
  { 
    "mfussenegger/nvim-lint",
    config = function() 
      local nvim_lint = require("lint")
      nvim_lint.linters_by_ft = {
        kotlin = {"ktlint"}
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          nvim_lint.try_lint()
        end,
      })
    end
  },

  -- Fuzzy Finder
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", function() require('telescope.builtin').find_files()  end, mode = "n", desc = "Find Files" },
      { "<leader>fg", function() require('telescope.builtin').live_grep() end, mode = "n", desc = "Live Grep" },
      { "<leader>fb", function() require('telescope.builtin').buffers() end, mode = "n", desc = "Find buffers" },
      { "<leader>f*", function() require('telescope.builtin').grep_string() end, mode = "n", desc = "Find string" },
      { "<leader>fh", function() require('telescope.builtin').help_tags() end, mode = "n", desc = "Find help tags" },
      { "<leader>fc", function() require('telescope.builtin').resume() end, mode = "n", desc = "Resume Search" },
      { "<leader>fr", function() require('telescope.builtin').lsp_references() end, mode = "n", desc = "[LSP] Find references" },
      { "<leader>fd", function() require('telescope.builtin').lsp_definitions() end, mode = "n", desc = "[LSP] Find definitions" },
      { "<leader>fo", function() require('telescope.builtin').lsp_outgoing_calls() end, mode = "n", desc = "[LSP] Find outgoing calls" },
      { "<leader>fi", function() require('telescope.builtin').lsp_incoming_calls() end, mode = "n", desc = "[LSP] Find incoming calls" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.load_extension('media_files')
      local actions = require "telescope.actions"
      telescope.setup {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<C-c>"] = actions.close,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,

              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            },

            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,

              ["?"] = actions.which_key,
            },
          },
        },
        -- pickers = {
          -- Default configuration for builtin pickers goes here:
          -- picker_name = {
          --   picker_config_key = value,
          --   ...
          -- }
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
        -- },
        extensions = {
          media_files = {
              -- filetypes whitelist
              -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
              filetypes = {"png", "webp", "jpg", "jpeg"},
              find_cmd = "rg" -- find command (defaults to `fd`)
            }
          -- Your extension configuration goes here:
          -- extension_name = {
          --   extension_config_key = value,
          -- }
          -- please take a look at the readme of the extension you want to configure
        },
      }
    end
  },
  { "nvim-telescope/telescope-media-files.nvim" },

  -- Syntax Highlighting
  -- Treesitter
  -- Treesitter
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   version = "v0.9.1",
  --   build = ":TSUpdate",
  --   config = function()
  --     local treesitter_configs = require("nvim-treesitter.configs")
  --     treesitter_configs.setup {
  --       ensure_installed = "all",
  --       sync_install = false,
  --       ignore_install = { "" }, -- List of parsers to ignore installing
  --       autopairs = {
  --         enable = true
  --       },
  --       highlight = {
  --         enable = true, -- false will disable the whole extension
  --         disable = { "" }, -- list of language that will be disabled
  --         additional_vim_regex_highlighting = true,
  --       },
  --       indent = { enable = true, disable = { "yaml" } },
  --     }
  --   end
  -- },

  -- Markdown
  -- previews
  -- install without yarn or npm
  -- { 
  --   "iamcco/markdown-preview.nvim",
  --   build = function() vim.fn["mkdp#util#install"]() end,
  -- },

  -- Kotlin
  -- kotlin vim support
  { "udalov/kotlin-vim" },
  -- kotlin LSP
  { "fwcd/kotlin-language-server" },

  -- Rust
  { 'simrat39/rust-tools.nvim' },

  -- Zig
  { 'ziglang/zig.vim' },

  -- Editing
  --
  { "tpope/vim-surround" },
  { "tpope/vim-commentary" },
  -- Autopairs, integrates with both cmp and treesitter
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      enable_check_bracket_line = false,
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      -- fast_wrap = {},
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'", "`", "<" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
  },

  -- git
  { "tpope/vim-fugitive" },
  { 
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎"},
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "┆ " },
      },
      signs_staged = {
        add = { text = "▎"},
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "┆ " },
      },
      -- signs_staged_enabled = true,
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000,
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    }
  },

  -- Testing
  { 
    'rcasia/neotest-java',
    -- ft = 'java',
    dependencies = {
      "mfussenegger/nvim-jdtls"
    },
  },
  { 
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rcasia/neotest-java",
    },
    opts = function() 
      return {
      adapters = {
        require("neotest-java"),
        -- "neotest-java",
        -- ["neotest-java"] = {
        --   incremental_build = false,
        -- },
      },
      log_level = vim.log.levels.TRACE,
    }
    end,
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end, mode = "n", desc = "Run nearest tests" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, mode = "n", desc = "Run tests in current buffer" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, mode = "n", desc = "Open test output" },
      { "<leader>tp", function() require("neotest").output_panel.toggle() end, mode = "n", desc = "Toggle output panel" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, mode = "n", desc = "Toggle test summery" },
    }
  },
  { "nvim-neotest/neotest-vim-test" },
  { "vim-test/vim-test" },

  -- DB
  {
  'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- http client
  -- {
  --   "rest-nvim/rest.nvim",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     opts = function (_, opts)
  --       opts.ensure_installed = opts.ensure_installed or {}
  --       table.insert(opts.ensure_installed, "http")
  --     end,
  --   }
  -- },
  { 'mistweaverco/kulala.nvim', opts = {} },

  -- progress bar for LSP
  {
    "j-hui/fidget.nvim",
    tag = "v1.4.5", -- Make sure to update this to something recent!
    opts = {
      -- options
    },
  },

  -- AI
  --
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>"
        },
        layout = {
          position = "bottom", -- | top | left | right | horizontal | vertical
          ratio = 0.4
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = 'node', -- Node.js version must be > 18.x
      server_opts_overrides = {},
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      provider = "ollama",
      ollama = {
        api_key_name = "",
        endpoint = "http://127.0.0.1:11434",
        model = "gemma3",
      },
      vendors = {
        ['ollama-starcoder2:15b'] = {
          __inherited_from = "ollama",
          model = "starcoder2:15b",
        },
        ['ollama-qwen:8b'] = {
          __inherited_from = "ollama",
          model = "qwen3:8b",
        }
      },
      -- add any opts here
      -- for example
      -- provider = "copilot",
      -- copilot = {
      --   endpoint = "https://api.openai.com/v1",
      --   model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
      --   timeout = 30000, -- timeout in milliseconds
      --   temperature = 0, -- adjust if needed
      --   max_tokens = 4096,
      --   -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
      -- },
    },
    behaviour = {
      auto_apply_diff_after_generation = true,
      enable_cursor_planning_mode = true,
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    opts = {
      adapters = {
        opts = {
          show_model_choices = true,
        },
      },
      strategies = {
        chat = {
          adapter = "ollama",
        },
        inline = {
          adapter = "ollama",
        }
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    -- Make sure to set this up properly if you have lazy=true
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { "markdown", "Avante", "codecompanion" },
    },
    ft = { "markdown", "Avante", "codecompanion" },
  },
  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },
}
