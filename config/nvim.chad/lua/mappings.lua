require "nvchad.mappings"

local map = vim.keymap.set

-- unchad
vim.keymap.del("i", "<C-b>")
vim.keymap.del("i", "<C-e>")
vim.keymap.del("i", "<C-h>")
vim.keymap.del("i", "<C-j>")
vim.keymap.del("i", "<C-k>")
vim.keymap.del("i", "<C-l>")
vim.keymap.del("n", "<C-c>")
vim.keymap.del("n", "<C-s>")
vim.keymap.del("n", "<Leader>/")
vim.keymap.del("n", "<Leader>b")
vim.keymap.del("n", "<Leader>cc")
vim.keymap.del("n", "<Leader>ch")
vim.keymap.del("n", "<Leader>cm")
vim.keymap.del("n", "<Leader>ds")
vim.keymap.del("n", "<Leader>e")
vim.keymap.del("n", "<Leader>fa")
vim.keymap.del("n", "<Leader>fb")
vim.keymap.del("n", "<Leader>ff")
vim.keymap.del("n", "<Leader>fh")
vim.keymap.del("n", "<Leader>fm")
vim.keymap.del("n", "<Leader>fo")
vim.keymap.del("n", "<Leader>fw")
vim.keymap.del("n", "<Leader>fz")
vim.keymap.del("n", "<Leader>gt")
vim.keymap.del("n", "<Leader>h")
vim.keymap.del("n", "<Leader>ma")
vim.keymap.del("n", "<Leader>n")
vim.keymap.del("n", "<Leader>pt")
vim.keymap.del("n", "<Leader>rn")
vim.keymap.del("n", "<Leader>th")
vim.keymap.del("n", "<Leader>v")
vim.keymap.del("n", "<Leader>x")
vim.keymap.del("n", "<S-Tab>")
vim.keymap.del("n", "<Tab>")
vim.keymap.del("n", "<leader>wK")
vim.keymap.del("n", "<leader>wk")
vim.keymap.del("t", "<C-x>")
vim.keymap.del("v", "<Leader>/")

-- keep chad?
-- vim.keymap.del("n", "<C-n>")
-- vim.keymap.del({ "n", "t" }, "<A-v>")
-- vim.keymap.del({ "n", "t" }, "<A-h>")
-- vim.keymap.del({ "n", "t" }, "<A-i>")

map("i", "jk", "<Esc>")
map("n", ";", ":")
map("n", "<CR>", "<Cmd>nohlsearch<CR>")
map("n", "<A-t>", "<Cmd>Telescope<CR>")
map("n", "<Leader>t", "<Plug>(CommandT)")
map("n", "<Leader>b", "<Plug>(CommandTBuffer)")
map("n", "<Leader>w", "<Cmd>vsplit<CR>")
map("n", "<Leader>h", "<Cmd>split<CR>")

local nvim_tmux_nav = require('nvim-tmux-navigation')

map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
