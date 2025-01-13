return {
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
            vim.g.undotree_SetFocusWhenToggle = true
        end,
    },
}
