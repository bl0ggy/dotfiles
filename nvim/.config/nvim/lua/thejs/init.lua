require("thejs.remap")
require("thejs.set")
require("thejs.lazy")

vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    float = true,
    signs = true,
    underline = true,
    severity_sort = false,
})

vim.cmd.colorscheme("catppuccin")
