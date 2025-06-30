--
-- OPTIONS
--

-- :help options
-- :browse set
-- :options
local opt = vim.opt

opt.backup = false
opt.clipboard:append "unnamedplus"
opt.cmdheight = 2

-- Faster reaction time 
opt.timeoutlen = 300
opt.updatetime = 300

-- Completion
opt.completeopt = { "menuone", "noinsert", "noselect" }

opt.conceallevel = 0
opt.fileencoding = "utf-8"

-- Proper search
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.smartcase = true

-- enable Mouse
opt.mouse = "a"

opt.pumheight = 10
opt.showmode = false
opt.showtabline = 2

-- Sane splits
-- opt.splitbelow = true
-- opt.splitright = true
--
opt.swapfile = false
opt.termguicolors = true
opt.undofile = true
opt.writebackup = false

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

-- Decent wildmenu
opt.wildmenu = true
opt.wildmode = "longest,full"
vim.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.jpeg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,*.o,*.class"

opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.shortmess:append "c"

-- GUI settings
opt.lazyredraw = true
opt.cursorline = true
opt.cursorlineopt = { "number" }

-- Number Column
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.guifont = "monospace:h17"

opt.showcmd = true


vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=~]]

-- Wrapping options
vim.cmd [[set formatoptions-=cro]]

--
-- KEYMAPS
--

local general_keymap_opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- shorten function name
local keymap = vim.api.nvim_set_keymap

-- Leader key
keymap("", " ", "<Nop>", general_keymap_opts)
vim.g.mapleader = " "
vim.g.maploacalleader = " "

-- Modes
-- normal mode = "n"
-- insert mode = "i"
-- visual mode = "v"
-- visual block mode = "x"
-- term mode = "t"
-- command mode = "c"

-- Normal --
--keymap("n", "<C-h>", "<C-w>h", general_keymap_opts)
--keymap("n", "<C-j>", "<C-w>j", general_keymap_opts)
--keymap("n", "<C-k>", "<C-w>k", general_keymap_opts)
--keymap("n", "<C-l>", "<C-w>l", general_keymap_opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +1<CR>", general_keymap_opts)
keymap("n", "<C-Down>", ":resize -3<CR>", general_keymap_opts)
keymap("n", "<C-Left>", ":vertical resize -3<CR>", general_keymap_opts)
keymap("n", "<C-Right>", ":vertical resize +1<CR>", general_keymap_opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", general_keymap_opts)
keymap("n", "<S-h>", ":bprevious<CR>", general_keymap_opts)

-- Move text line up and down
keymap("n", "<A-j>", ":m .+0<CR>==", general_keymap_opts)
keymap("n", "<A-k>", ":m .-3<CR>==", general_keymap_opts)

-- Insert --
-- Press jj fast to exit
keymap("i", "jj", "<ESC>", general_keymap_opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", general_keymap_opts)
keymap("v", ">", ">gv", general_keymap_opts)

-- Move text lines up and down
keymap("v", "<A-j>", ":m '>+0<CR>gv-gv", general_keymap_opts)
keymap("v", "<A-k>", ":m '<-3<CR>gv-gv", general_keymap_opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

keymap("n", "n", "nzz", term_opts)
keymap("n", "N", "Nzz", term_opts)

-- plugin manager: lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("user.plugins", {
  rocks = { enabled = false },
  dev = {
    path = "~/.local/share/nvim/nix",
    patterns = { "nvim-treesitter" },
    fallback = false,
  }
})

--
-- COLORSCHEME 
--
local colorscheme = "duskfox"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

--
-- Completion
--
local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--
-- LSP
--
local lsp_status_ok, lspconfig = pcall(require, "lspconfig")
if not lsp_status_ok then
  print('LSP not loaded')
end

if lsp_status_ok then
  local function lsp_highlight_document(client)
    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlight then
      vim.api.nvim_exec(
        [[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]],
        false
      )
    end
  end

  --- Rust LSP
  local rt = require("rust-tools")

  rt.setup({
    server = opts
  })
end
