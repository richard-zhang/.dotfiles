-- print("load packer plugins")
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use "neovim/nvim-lspconfig"

  use "williamboman/nvim-lsp-installer"
  use "preservim/nerdtree"
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ':TSUpdate'
  }
  -- use "sheerun/vim-polyglot"
  -- use "tjdevries/colorbuddy.nvim"
  -- use "tjdevries/gruvbuddy.nvim"
  use "tomasiser/vim-code-dark"
  use "Olical/conjure"
  use {
        "nvim-telescope/telescope.nvim",
        requires = { {'nvim-lua/plenary.nvim'} }
  }
  use "bfredl/nvim-luadev"
  use { "catppuccin/nvim", as = "catppuccin" }
  use { "ray-x/lsp_signature.nvim" }
  use {
    'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  }

  -- use 'ms-jpq/coq_nvim'
  -- use 'ms-jpq/coq.artifacts'
  -- use 'ms-jpq/coq.thirdparty'
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
end)
