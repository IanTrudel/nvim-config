vim.keymap.set({ 'n', 'v' }, '-', '<Nop>', { silent = true })

vim.api.nvim_set_keymap('n', '<F2>', ':set paste!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', '<<', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', '<C-d>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>e', ':lua ToggleNetrw()<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>tt", function()
   require("trouble").toggle()
end, { desc = "Toggle Trouble window" })

vim.keymap.set("n", "<leader>ts", ":so %<CR>")

vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, { desc = "Code action" })
vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, { desc = "References" })
vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, { desc = "Rename (refactor)" })
vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { desc = "Signature" })

vim.api.nvim_set_keymap('n', '<BS>', ':close<CR>', { noremap = true, silent = true, desc = "Close buffer/window" })

vim.keymap.set("n", "<leader>ss", function()
  require("plugins.sniperscope").toggle()
end, { desc = "Toggle Sniper Scope" })
