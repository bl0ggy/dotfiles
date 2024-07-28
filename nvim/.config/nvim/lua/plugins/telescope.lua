return {
    {
        "BurntSushi/ripgrep",
    },
    {
        "sharkdp/fd",
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local telescope = require('telescope')
            telescope.setup({
                pickers = {
                    find_files = {
                        hidden = true
                    },
                },
            })

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>pp', builtin.git_files, {})
            vim.keymap.set('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
        end,
    },
}
