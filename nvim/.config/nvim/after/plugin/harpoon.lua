require("harpoon").setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
    },
    tabline = true
})
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<D-:>", mark.add_file)
vim.keymap.set("n", "<D-=>", ui.toggle_quick_menu)
vim.keymap.set("n", "<D-,>", ui.nav_prev)
vim.keymap.set("n", "<D-;>", ui.nav_next)

vim.keymap.set("i", "<D-:>", "<ESC><D-:>")
vim.keymap.set("i", "<D-=>", "<ESC><D-=>")
vim.keymap.set("i", "<D-,>", "<ESC><D-,>")
vim.keymap.set("i", "<D-;>", "<ESC><D-;>")
