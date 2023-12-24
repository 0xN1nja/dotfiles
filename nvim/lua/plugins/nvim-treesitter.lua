require("nvim-treesitter.configs").setup({
  ensure_installed = { "python", "rust", "javascript", "typescript", "lua" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
})
