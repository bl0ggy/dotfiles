local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- From lazy author
    { 'folke/lazy.nvim' },   -- Lazy itself
    { 'folke/neodev.nvim' }, -- Vim global variable for lua

    -- Schemes
    {
        'rose-pine/neovim',
        name = 'rose-pine'
    },
    { 'rebelot/kanagawa.nvim' },
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        opts = {},
    },

    -- Required by nvim-telescope/telescope
    { 'BurntSushi/ripgrep' },
    { 'sharkdp/fd' },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {
        'nvim-treesitter/nvim-treesitter', -- Symbol tree
        build = ':TSUpdate'
    },
    { 'theprimeagen/harpoon' }, -- File switcher
    { 'mbbill/undotree' },

    -- Git
    { 'tpope/vim-fugitive' },
    { 'airblade/vim-gitgutter' },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    {
        'numToStr/Comment.nvim',
        lazy = false,
    },

    -- VonHeikemen/lsp-zero.nvim
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x'
    },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    -- { 'ray-x/lsp_sinature.nvim' },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    },
})
