-- vim.api.nvim_create_autocmd('ColorScheme', {
--     callback = function(args)
--         -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--         -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--     end,
-- })

return {
    -- {
    --     "zaldih/themery.nvim",
    --     lazy = false,
    --     opts = {
    --         themes = {
    --             "catppuccin",
    --             "catppuccin-mocha",
    --             "catppuccin-frappe",
    --             "catppuccin-latte",
    --             "catppuccin-macchiato",
    --             "tokyonight",
    --             "tokyonight-day",
    --             "tokyonight-moon",
    --             "tokyonight-night",
    --             "tokyonight-storm",
    --             "kanagawa",
    --             "kanagawa-dragon",
    --             "kanagawa-lotus",
    --             "kanagawa-wave",
    --             "rose-pine",
    --             "rose-pine-dawn",
    --             "rose-pine-main",
    --            "rose-pine-moon",
    --         },
    --     },
    -- },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = true,
    },
    {
        "folke/tokyonight.nvim",
        lazy = true,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        opts = {
            flavour = "frappe", -- latte, frappe, macchiato, mocha
            background = {      -- :h background
                light = "latte",
                dark = "mocha",
            },
            transparent_background = true, -- disables setting the background color.
            show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
            term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
            dim_inactive = {
                enabled = false,            -- dims the background color of inactive window
                shade = "dark",
                percentage = 0.15,          -- percentage of the shade to apply to the inactive window
            },
            no_italic = false,              -- Force no italic
            no_bold = false,                -- Force no bold
            no_underline = false,           -- Force no underline
            styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
                comments = { "italic" },    -- Change the style of comments
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
                -- miscs = {}, -- Uncomment to turn off hard-coded styles
            },
            color_overrides = {},
            custom_highlights = {},
            default_integrations = true,
            -- integrations = {
            --     cmp = true,
            --     gitsigns = true,
            --     nvimtree = true,
            --     treesitter = true,
            --     notify = false,
            --     mini = {
            --         enabled = true,
            --         indentscope_color = "",
            --     },
            --     -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            -- },
        }
    },
}
