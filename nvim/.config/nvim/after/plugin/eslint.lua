vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.js', '*.ts', '*.jsx', '*.tsx' },
    command = 'silent! EslintFixAll',
    group = vim.api.nvim_create_augroup('MyFormatOnSaveEslint', {}),
})
