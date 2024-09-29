local augroup = vim.api.nvim_create_augroup('MyLspFormatOnSave', {})
vim.api.nvim_clear_autocmds({ group = augroup })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    callback = function()
        vim.lsp.buf.format()
    end
})

return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = true,
    },
    -- {
    --     "williamboman/mason-lspconfig.nvim",
    --     config = {
    --         local lsp = require("lsp-zero")
    --         require("mason-lspconfig").setup({
    --             handlers = {
    --                 lsp.default_setup,
    --             },
    --         })
    --     },
    -- },
    -- {
    --     "hrsh7th/cmp-nvim-lsp",
    -- },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                "nvim-cmp/lua/cmp/types",
            },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            local cmp = require("cmp")
            cmp.setup({
                formatting = lsp_zero.cmp_format({ details = true }),
                mapping = cmp.mapping.preset.insert({
                    ['<Down>'] = cmp.mapping(function(fallback)
                        cmp.close()
                        fallback()
                    end, { "i" }),
                    ['<Up>'] = cmp.mapping(function(fallback)
                        cmp.close()
                        fallback()
                    end, { "i" }),
                    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                    -- ["<ESC>"] = cmp.mapping.abort(),        -- close completion window
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),
                sorting = {
                    priority_weight = 1,
                    comparators = {
                        function(entry1, entry2)
                            local result = vim.stricmp(entry1.completion_item.label, entry2.completion_item.label)
                            if (result < 0) then
                                return true
                            end
                            return false
                        end,
                        cmp.config.compare.sort_text,
                    },
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            --- If you want to know more about lsp-zero and mason.nvim
            --- Read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            lsp_zero.on_attach(function(client, bufnr)
                -- See :help lsp-zero-keybindings
                -- To learn the available actions
                -- lsp_zero.default_keymaps({buffer = bufnr})
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "gd", function()
                    vim.lsp.buf.definition()
                end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.lsp.buf.open_flat() end, opts)
                vim.keymap.set("n", "[d", function() vim.lsp.buf.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.lsp.buf.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end)

            require('mason-lspconfig').setup({
                ensure_installed = {},
                handlers = {
                    -- This first function is the "default handler"
                    -- It applies to every language server without a "custom handler"
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                }
            })
        end
    },
    {
        "L3MON4D3/LuaSnip",
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            require "lsp_signature".setup(opts)
        end,
    },
}
