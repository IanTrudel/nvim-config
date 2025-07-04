-- Setup leader key
vim.g.mapleader = '-'
vim.g.maplocalleader = '-'

require('lazyvim')
require('options')
require('keymaps')
--require('relcolnum')

-- See :highlight
vim.cmd [[highlight Normal guibg=#00000000]]
vim.cmd [[highlight LineNr guifg=#9c9486]]
vim.cmd [[highlight Whitespace guifg=#5e5b55]]
vim.cmd [[highlight CursorLineNr guibg=LightGrey]]

vim.cmd.aunmenu { 'PopUp.How-to\\ disable\\ mouse' }
vim.cmd.aunmenu { 'PopUp.-1-' }

-- Save and restore cursor position when a file is closed and reopened
vim.cmd [[
  if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  endif
]]

vim.api.nvim_create_autocmd('FileType', {
   pattern = '*',
   callback = function()
      vim.o.tabstop = 3
      vim.o.shiftwidth = 3
      vim.o.softtabstop = 0
      vim.o.expandtab = true
      vim.o.smarttab = true
   end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
   pattern = "*.sim",
   command = "setfiletype simula"
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
   pattern = "*.FCMacro",
   command = "setfiletype python"
})

-- vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
--   pattern = "*.icn",
--    command = "setfiletype icon"
-- })

vim.cmd [[filetype plugin on]]

function ToggleNetrw()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in pairs(buffers) do
    if vim.bo[buf].filetype == 'netrw' then
      vim.api.nvim_buf_delete(buf, {})
      return
    end
  end
  vim.cmd 'Explore'
end

-- load project specific Neovim configuration file.
local function load_project_config()
  local cmd = vim.fn.getcwd()
  local project_name = string.match(cmd, '/([^/]+)$')

  local project_config_path = string.format('%s/projects/%s.lua', vim.fn.stdpath 'config', project_name)

  if vim.fn.filereadable(project_config_path) == 1 then
    dofile(project_config_path)
  end
end

load_project_config()
