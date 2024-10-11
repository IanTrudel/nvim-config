-- Setup LazyVim
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

require("lazy").setup({
   "folke/which-key.nvim",
   { "folke/neoconf.nvim", cmd = "Neoconf" },
   "folke/neodev.nvim",
   {
      -- LSP Configuration & Plugins
      'neovim/nvim-lspconfig',
      dependencies = {
         -- Automatically install LSPs to stdpath for neovim
         'williamboman/mason.nvim',
         'williamboman/mason-lspconfig.nvim',

         -- Useful status updates for LSP
         -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
         { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

         -- Additional lua configuration, makes nvim stuff amazing!
         'folke/neodev.nvim',
      },
   },
   {
      -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
         'nvim-treesitter/nvim-treesitter-textobjects',
         'nvim-treesitter/playground',
      },
      build = ':TSUpdate',
   },
   -- Fuzzy Finder (files, lsp, etc)
   {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
         'nvim-lua/plenary.nvim',
         -- Fuzzy Finder Algorithm which requires local dependencies to be built.
         -- Only load if `make` is available. Make sure you have the system
         -- requirements installed.
         {
            'nvim-telescope/telescope-fzf-native.nvim',
            -- NOTE: If you are having trouble with this installation,
            --       refer to the README for telescope-fzf-native for more instructions.
            build = 'make',
            cond = function()
               return vim.fn.executable 'make' == 1
            end,
         },
      },
   },
   {
      -- Autocompletion
      'hrsh7th/nvim-cmp',
      dependencies = {
         -- Snippet Engine & its associated nvim-cmp source
         'L3MON4D3/LuaSnip',
         'saadparwaiz1/cmp_luasnip',

         -- Adds LSP completion capabilities
         'hrsh7th/cmp-nvim-lsp',
         'hrsh7th/cmp-nvim-lua',
         'hrsh7th/cmp-path',
         'hrsh7th/cmp-buffer'

         -- Adds a number of user-friendly snippets
         -- 'rafamadriz/friendly-snippets',
      },
   },
   {
      -- Set lualine as statusline
      'nvim-lualine/lualine.nvim',
      -- See `:help lualine.txt`
      opts = {
         options = {
            icons_enabled = false,
            theme = 'onedark',
            component_separators = '|',
            section_separators = '',
         },
      },
      dependencies = { "nvim-tree/nvim-web-devicons" },
   },
   {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
         -- your configuration comes here
         -- or leave it empty to use the default settings
         -- refer to the configuration section below
   	},
   },
   {
      -- Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
         -- See `:help gitsigns.txt`
         signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
         },
         on_attach = function(bufnr)
            vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

            -- don't override the built-in and fugitive keymaps
            local gs = package.loaded.gitsigns
            vim.keymap.set({ 'n', 'v' }, ']c', function()
               if vim.wo.diff then
                  return ']c'
               end
               vim.schedule(function()
                  gs.next_hunk()
               end)
               return '<Ignore>'
            end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
            vim.keymap.set({ 'n', 'v' }, '[c', function()
               if vim.wo.diff then
                  return '[c'
               end
               vim.schedule(function()
                  gs.prev_hunk()
               end)
               return '<Ignore>'
            end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
         end,
      },
   },
   { "nvim-lua/plenary.nvim", lazy = true },
   { 'rasulomaroff/reactive.nvim' },
   -- { "nvimtools/none-ls.nvim" },
   -- https://github.com/ThePrimeagen/refactoring.nvim
   {
      'sainnhe/gruvbox-material',
      lazy = false,
      priority = 1000,
      config = function()
         vim.g.gruvbox_material_better_performance = true
         vim.cmd 'colorscheme gruvbox-material'
      end,
   },
})

require('neodev').setup()
require('plugins.telescope').setup()
require('plugins.treesitter').setup()
require('plugins.lsp').setup()
require('reactive').setup({
   builtin = {
      cursorline = true,
      cursor = true,
      modemsg = true
   },
})
