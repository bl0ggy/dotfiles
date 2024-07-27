local lsp = require('lsp-zero')

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({ buffer = bufnr })
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

    -- How to avoid formatting conflict
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
    local augroup = vim.api.nvim_create_augroup('MyLspFormatOnSaveAll', {})
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format()
            print("formating")
            -- vim.lsp.buf.format({
            --     bufnr = bufnr,
            --     filter = function(client_)
            --         -- apply whatever logic you want (in this example, we'll only use null-ls)
            --         local bufname = vim.api.nvim_buf_get_name(bufnr)
            --         -- local extjs = bufname:match(".*%.js$")
            --         -- local extts = bufname:match(".*%.ts$")
            --         -- local extjsx = bufname:match(".*%.jsx$")
            --         -- local exttsx = bufname:match(".*%.tsx$")
            --         -- if (extjs or extts or extjsx or exttsx) then
            --         --     -- Uses formatter in after/plugin/eslint.lua
            --         --     return
            --         -- end
            --         -- return client_.name
            --
            --         -- print("bufname" .. bufname)
            --         if (
            --                 bufname:match(".*%.cpp$") or
            --                 bufname:match(".*%.h$")
            --             ) then
            --             -- print("match")
            --             return true
            --         end
            --
            --         -- print("no match")
            --         return false
            --     end,
            -- })
        end,
    })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        lsp.default_setup,
    },
})
