require("thejs.remap")
require("thejs.set")
require("thejs.lazy")

vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = true,
    float = true,
    signs = true,
    underline = true,
    severity_sort = false,
})

vim.cmd.colorscheme("catppuccin")
vim.g.netrw_sort_sequence = '[\\/]$,^\\d\\.cpp$,^\\d\\d\\.cpp$,^\\d\\d\\d\\.cpp$,^\\d\\d\\d\\d\\.cpp$,*'
