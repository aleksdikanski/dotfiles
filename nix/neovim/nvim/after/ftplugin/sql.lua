-- shorten function name
local keymap = vim.api.nvim_set_keymap

-- Modes
-- normal mode = "n"
-- insert mode = "i"
-- visual mode = "v"
-- visual block mode = "x"
-- term mode = "t"
-- command mode = "c"
local general_keymap_opts = { noremap = true, silent = true }

keymap("n", "<leader>j", "<Plug>(DBUI_ExecuteQuery)", general_keymap_opts)
keymap("v", "<leader>j", "<Plug>(DBUI_ExecuteQuery)", general_keymap_opts)
