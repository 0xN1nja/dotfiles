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

local plugins = {
  "goolord/alpha-nvim",
  "folke/tokyonight.nvim",
  "ellisonleao/gruvbox.nvim",
  "Mofiqul/vscode.nvim",
  "navarasu/onedark.nvim",
  "akinsho/bufferline.nvim",
  "nvim-lualine/lualine.nvim",
  "nvim-tree/nvim-web-devicons",
  "nvim-tree/nvim-tree.lua",
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-treesitter/nvim-treesitter",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "numToStr/Comment.nvim",
  "lewis6991/gitsigns.nvim",
  "windwp/nvim-autopairs",
  "windwp/nvim-ts-autotag",
  "smjonas/inc-rename.nvim",
  "folke/persistence.nvim",
  "folke/trouble.nvim",
}

local opts = {}

require("lazy").setup(plugins, opts)
