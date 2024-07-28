return {
    {
        "williamboman/mason.nvim",
    },
    {
        "williamboman/mason-lspconfig.nvim",
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
    },
    {
        "neovim/nvim-lspconfig",
    },
    -- {
    --     "hrsh7th/cmp-nvim-lsp",
    -- },
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
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
