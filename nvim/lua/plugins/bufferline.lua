vim.opt.termguicolors = true

require("bufferline").setup()

vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", {})
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", {})
