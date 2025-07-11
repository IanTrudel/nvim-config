local M = {}

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
   -- NOTE: Remember that lua is a real programming language, and as such it is possible
   -- to define small helper and utility functions so you don't have to repeat yourself
   -- many times.
   --
   -- In this case, we create a function that lets us more easily define mappings specific
   -- for LSP related items. It sets the mode, buffer and description for us each time.
   local nmap = function(keys, func, desc)
      if desc then
         desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
   end

   nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
   nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

   nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
   nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
   nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
   nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
   nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
   nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

   -- See `:help K` for why this keymap
   nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
   nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

   -- Lesser used LSP functionality
   nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
   nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
   nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
   nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
   end, '[W]orkspace [L]ist Folders')

   -- Create a command `:Format` local to the LSP buffer
   vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
   end, { desc = 'Format current buffer with LSP' })
end

M.setup = function()
   -- document existing key chains
   require('which-key').add {
      { "<leader>c", group = "[C]ode" },
      { "<leader>c_", hidden = true },
      { "<leader>d", group = "[D]ocument" },
      { "<leader>d_", hidden = true },
      { "<leader>g", group = "[G]it" },
      { "<leader>g_", hidden = true },
      { "<leader>h", group = "More git" },
      { "<leader>h_", hidden = true },
      { "<leader>r", group = "[R]ename" },
      { "<leader>r_", hidden = true },
      { "<leader>s", group = "[S]earch" },
      { "<leader>s_", hidden = true },
      { "<leader>w", group = "[W]orkspace" },
      { "<leader>w_", hidden = true },
   }

   -- mason-lspconfig requires that these setup functions are called in this order
   -- before setting up the servers.
   require('mason').setup()
   require('mason-lspconfig').setup()

   local servers = {
      clangd = {},
      rust_analyzer = {},
      pyright = {
         settings = {
            python = {
               analysis = {
                  autoSearchPaths = true,
                  diagnosticMode = 'workspace',
                  useLibraryCodeForTypes = true
               }
            }
         }
      },
      texlab = {},

      lua_ls = {
         Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { disable = { 'missing-fields' } },
         },
      },
   }

   --[[local null_ls = require("null-ls")

   null_ls.setup({
      sources = {
         null_ls.builtins.formatting.stylua,
         null_ls.builtins.diagnostics.eslint,
         null_ls.builtins.completion.spell,
      },
   })]]

   -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
   local capabilities = vim.lsp.protocol.make_client_capabilities()
   capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

   capabilities.textDocument.completion.completionItem.snippetSupport = false

   -- Ensure the servers above are installed
   local mason_lspconfig = require('mason-lspconfig')

   -- mason_lspconfig.setup {
   --    ensure_installed = vim.tbl_keys(servers),
   -- }

--   mason_lspconfig.setup_handlers {
--      function(server_name)
--         require('lspconfig')[server_name].setup {
--            capabilities = capabilities,
--            on_attach = on_attach,
--            settings = servers[server_name],
--            filetypes = (servers[server_name] or {}).filetypes,
--         }
--      end,
--   }

   -- [[ Configure nvim-cmp ]]
   -- See `:help cmp`
   local cmp = require 'cmp'
   local luasnip = require 'luasnip'
   require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/lua/snippets" } })
   require('luasnip.loaders.from_vscode').lazy_load()
   luasnip.config.setup {}

   local function check_backspace()
      local col = vim.fn.col('.') - 1
      return col == 0 or (col > 0 and vim.fn.getline('.'):sub(col, col):match('%s') ~= nil)
   end

   cmp.setup {
      snippet = {
         expand = function(args)
            luasnip.lsp_expand(args.body)
         end,
      },
      --[[ window = {
         completion = cmp.config.window.bordered(),
         documentation = cmp.config.window.bordered(),
      }, --]]
      mapping = cmp.mapping.preset.insert {
         ['<C-n>'] = cmp.mapping.select_next_item(),
         ['<C-p>'] = cmp.mapping.select_prev_item(),
         ['<C-d>'] = cmp.mapping.scroll_docs(-4),
         ['<C-f>'] = cmp.mapping.scroll_docs(4),
         ['<C-Space>'] = cmp.mapping.complete {},
         ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
         },
         ['<Tab>'] = cmp.mapping(function(fallback)
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
        end, {'i', 's'}),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {'i', 's'}),
      },
      sources = {
         { name = 'nvim_lsp' },
         { name = 'luasnip' },
         { name = 'path' },
      },
   }
end

return M
