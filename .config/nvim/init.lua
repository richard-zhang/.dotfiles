local fn = vim.fn
if vim.loop.os_uname().sysname == "Darwin"
then
  print("mac use paq-nvim")
  
  local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
  
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
  end
  
  require "paq" {
      "savq/paq-nvim";                  -- Let Paq manage itself
  
      "neovim/nvim-lspconfig";          -- Mind the semi-colons
      "nvim-lua/completion-nvim";
      "hrsh7th/nvim-cmp";
      "kabouzeid/nvim-lspinstall";
    
      "preservim/nerdtree";
      "nvim-treesitter/nvim-treesitter";
      "sheerun/vim-polyglot";
      "tjdevries/colorbuddy.nvim";
      "tjdevries/gruvbuddy.nvim";
    
      "Olical/conjure";
      "nvim-telescope/telescope.nvim";
  }
else
  print("linux use packer")
  require('plugins')
end

vim.o.termguicolors = true
vim.o.syntax = 'on'
vim.o.errorbells = false
vim.o.smartcase = true
vim.o.showmode = false
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
key_mapper('i', 'jk', '<ESC>')
key_mapper('i', 'JK', '<ESC>')
key_mapper('i', 'jK', '<ESC>')
key_mapper('v', 'jk', '<ESC>')
key_mapper('v', 'JK', '<ESC>')
key_mapper('v', 'jK', '<ESC>')
key_mapper('n', '<F6>', ':vsp ~/.config/nvim/init.lua<CR>')
key_mapper('n', '<F7>', ':so %<CR>')
key_mapper('n', '<F8>', ':NERDTreeToggle<CR>')

require('colorbuddy').colorscheme('gruvbuddy')

local configs = require'nvim-treesitter.configs'
configs.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  }
}

-- lsp setup
--
local lspconfig = require'lspconfig'
local completion = require'completion'

local function custom_on_attach(client)
  print('Attaching to ' .. client.name)
  completion.on_attach()
  key_mapper('n', '<leader>dn', 'vim.lsp.diagnostic.goto_next()')
  key_mapper('n', '<leader>dp', 'vim.lsp.diagnostic.goto_prev()')
end

local default_config = {
  on_attach = custom_on_attach,
}

lspconfig.ocamllsp.setup{
  on_attach = custom_on_attach;
  cmd = { "ocamllsp" };
  filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason" };
  root_dir = function(fname)
    return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
  end;
  settings = {};
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)

key_mapper('n', 'gf', ':lua vim.lsp.buf.formatting()<CR>')
key_mapper('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
key_mapper('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>')
key_mapper('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>')
key_mapper('n', 'gw', ':lua vim.lsp.buf.document_symbol()<CR>')
key_mapper('n', 'gW', ':lua vim.lsp.buf.workspace_symbol()<CR>')
key_mapper('n', 'gr', ':lua vim.lsp.buf.references()<CR>')
key_mapper('n', 'gt', ':lua vim.lsp.buf.type_definition()<CR>')
key_mapper('n', 'K', ':lua vim.lsp.buf.hover()<CR>')
key_mapper('n', 'gh', ':lua vim.lsp.buf.hover()<CR>')
key_mapper('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<CR>')
key_mapper('n', '<leader>af', ':lua vim.lsp.buf.code_action()<CR>')
key_mapper('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>')

require'lspinstall'.setup() -- important

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup(default_config)
end

-- Using Lua functions
key_mapper('n', '<c-p>', ':Telescope find_files<CR>')
key_mapper('n', '<leader>ff', ':Telescope find_files<CR>')
key_mapper('n', '<leader>fg', ':Telescope live_grep<CR>')
key_mapper('n', '<leader>fb', ':Telescope buffers<CR>')
key_mapper('n', '<leader>fh', ':Telescope help_tags<CR>')
