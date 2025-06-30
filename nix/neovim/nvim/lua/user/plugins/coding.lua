--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

return {
  -- Auto Completion: cmp
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      {
        "hrsh7th/cmp-buffer",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-cmdline",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-nvim-lsp",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-nvim-lua",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-path",
        event = "InsertEnter",
      },
      {
        "saadparwaiz1/cmp_luasnip",
        event = "InsertEnter",
      },
      {
        "tamago324/cmp-zsh",
        event = "InsertEnter",
      },
      {
        "andersevenrud/cmp-tmux",
        event = "InsertEnter",
      },
      -- {
      --   "Saecki/crates.nvim"
      --   event = "InsertEnter",
      -- },
      {
        "David-Kunz/cmp-npm",
        event = "InsertEnter",
      },
      {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
      },
      {
        "kristijanhusak/vim-dadbod-completion",
        event = "InsertEnter",
      }
    },
    config = function(plugin, opts)
      local cmp = require("cmp")

      cmp.setup(opts)

      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

      cmp.setup.filetype(
        { "sql" },
        { sources = {
          { name = "vim-dadbod-completion" },
          { name = "buffer " },
        }}
      )
    end,
    opts = function()
      local snip_status_ok, luasnip = pcall(require, "luasnip")
      if snip_status_ok then
        require("luasnip/loaders/from_vscode").lazy_load()
      end

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")

      return {
        completion = {
          -- autocomplete = false,
          completeopt = "menu,menuone,noinsert"
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For luasnip users
          end,
        },
        mapping = {
          ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
         -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          -- Accept currently selected item. If none selected, `select` first item.
          -- Set `select` to `false` to only confirm explicitly selected items.
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expandable() then
                luasnip.expand()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif check_backspace() then
                fallback()
              else
                fallback()
              end
            end,
            { "i", "s", }
          ),
          ["<S-Tab>"] = cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end,
            { "i", "s", }
          ),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = kind_icons[vim_item.kind]
            -- This concatenates the icons with the name of the item kind
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              nvim_lua = "[NVIM_LUA]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
        sources = cmp.config.sources(
          {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "luasnip" },
          },
          {
            { name = "buffer" },
            { name = "path" },
          }
        ),
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = {
            border = "rounded",
            scrollbar = false,
          },
          documentation = {
            border = "rounded",
          },
        },
        experimental = {
          ghost_text = false,
          native_menu = false,
        },
      }
    end
  }
}
