local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.stylua,
    },
})

vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format)
