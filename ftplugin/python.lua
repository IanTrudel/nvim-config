-- Print statement for debugging
-- print("Loading ftplugin/python.lua")

-- Override recommended style from /usr/local/share/nvim/runtime/ftplugin/python.vim
vim.g.python_recommended_style = 0

-- Set indentation options specific to Python files
vim.o.tabstop = 3
vim.o.shiftwidth = 3
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.smarttab = true

