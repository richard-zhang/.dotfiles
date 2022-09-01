local fn = vim.fn
-- if vim.loop.os_uname().sysname == "Darwin"
-- then

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
fn.system({'git', 'clone', '--depth=1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('plugins')

vim.o.termguicolors = true
vim.o.syntax = 'on'
vim.o.errorbells = false vim.o.smartcase = true vim.o.showmode = false
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt='menuone,noinsert,noselect'
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'
vim.wo.wrap = false

local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

key_mapper('', '<up>', '<nop>')
key_mapper('', '<down>', '<nop>')
key_mapper('', '<left>', '<nop>')
key_mapper('', '<right>', '<nop>')
-- key_mapper('i', 'jk', '<ESC>')
-- key_mapper('i', 'JK', '<ESC>')
-- key_mapper('i', 'jK', '<ESC>')
-- key_mapper('v', 'jk', '<ESC>')
-- key_mapper('v', 'JK', '<ESC>')
-- key_mapper('v', 'jK', '<ESC>')
key_mapper('n', '<F6>', ':vsp ~/.config/nvim/init.lua<CR>')
key_mapper('n', '<F7>', ':so %<CR>')
key_mapper('n', '<F8>', ':NERDTreeToggle<CR>')
key_mapper('n', '<F9>', ':vsp ~/.config/nvim/lua/plugins.lua<CR>')
-- key_mapper('i', '<C-space>', '<C-x><C-o>')
-- key_mapper('t', '<ESC>', '<c-\><c-n>')

-- color scheme
vim.cmd [[colorscheme codedark]]
-- vim.cmd [[colorscheme catppuccin]]
-- require('colorbuddy').colorscheme('gruvbuddy')

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  autopairs = {
		enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    -- disable = { "ruby" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
  },
  context_commentstring = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

-- lsp setup
--
-- lsp autocomplete
--
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require("nvim-lsp-installer").setup {}

local lspconfig = require'lspconfig'
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

vim.keymap.set('n', '<space>o', ':ClangdSwitchSourceHeader<cr>', opts)

local on_attach = function(client, bufnr)
  -- print('Attaching to ' .. client.name)
    -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gw', vim.lsp.buf.document_symbol, bufopts)
  vim.keymap.set('n', 'gW', vim.lsp.buf.workspace_symbol, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

  vim.keymap.set('n', '<space>ai', vim.lsp.buf.incoming_calls, bufopts)
  vim.keymap.set('n', '<space>ao', vim.lsp.buf.outgoing_calls, bufopts)
end

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.hls.setup({
  on_attach = on_attach,
  settings = {},
  capabilities = capabilities,
})

lspconfig.ocamllsp.setup({
  on_attach = on_attach,
  cmd = { "ocamllsp" },
  settings = {},
  capabilities = capabilities,
})

lspconfig.clangd.setup({
  on_attach = on_attach,
  cmd= {"clangd"},
  capabilities = capabilities,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- require("lsp_signature").setup()

-- key_mapper('n', 'gf', ':lua vim.lsp.buf.formatting()<CR>')
-- key_mapper('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
-- key_mapper('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>')
-- key_mapper('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>')
-- key_mapper('n', 'gw', ':lua vim.lsp.buf.document_symbol()<CR>')
-- key_mapper('n', 'gW', ':lua vim.lsp.buf.workspace_symbol()<CR>')
-- key_mapper('n', 'gr', ':lua vim.lsp.buf.references()<CR>')
-- key_mapper('n', 'gt', ':lua vim.lsp.buf.type_definition()<CR>')
-- key_mapper('n', 'K', ':lua vim.lsp.buf.hover()<CR>')
-- key_mapper('n', 'gh', ':lua vim.lsp.buf.hover()<CR>')
-- key_mapper('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<CR>')
-- key_mapper('n', '<leader>af', ':lua vim.lsp.buf.code:_action()<CR>')
-- key_mapper('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>')
-- 
-- Using Lua functions
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

key_mapper('n', '<c-p>', ':Telescope git_files<CR>')
key_mapper('n', '<leader>ff', ':Telescope find_files<CR>')
key_mapper('n', '<leader>fw', ':Telescope grep_string<CR>')
key_mapper('n', '<leader>fg', ':Telescope live_grep<CR>')
key_mapper('n', '<leader>fb', ':Telescope buffers<CR>')
key_mapper('n', '<leader>fh', ':Telescope help_tags<CR>')

key_mapper('n', '<F12>',  '<Plug>(Luadev-RunLine)')

-- ptyhon3 path
--
require('litee.lib').setup({})
-- call tree
require('litee.calltree').setup({})
-- symbol tree
require('litee.symboltree').setup({})

