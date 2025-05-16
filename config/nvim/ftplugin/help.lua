local map = vim.api.nvim_buf_set_keymap
local opts = { noremap = true, silent = true }

map(0, 'n', 'O', ":lua HelpJumps.option_prev()<CR>", opts)
map(0, 'n', 'S', ":lua HelpJumps.subject_prev()<CR>", opts)
map(0, 'n', 'o', ":lua HelpJumps.option_next()<CR>", opts)
map(0, 'n', 's', ":lua HelpJumps.subject_next()<CR>", opts)

HelpJumps = {}

function HelpJumps.option_next()
  vim.cmd([[normal! /'\l\{2,\}'\<CR>]])
end

function HelpJumps.option_prev()
  vim.cmd([[normal! ?'\l\{2,\}'\<CR>]])
end

function HelpJumps.subject_next()
  vim.cmd([[normal! /|.\{-}|\<CR>]])
end

function HelpJumps.subject_prev()
  vim.cmd([[normal! ?|.\{-}|\<CR>]])
end
