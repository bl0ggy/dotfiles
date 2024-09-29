vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Rex)

-- vim.keymap.set("n", "<C-u>", "<C-u>zz")               -- Page up centered
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")               -- Page down centered
-- vim.keymap.set("n", "<PageUp>", "<C-u>")              -- Move cursor up on scroll up
-- vim.keymap.set("n", "<S-Up>", "<C-u>")                -- Move cursor up on scroll up
-- vim.keymap.set("v", "<PageUp>", "<C-u>")              --
-- vim.keymap.set("i", "<PageUp>", "<C-O><C-u>")         --
-- vim.keymap.set("n", "<PageDown>", "<C-d>")            -- Move cursor down on scroll down
-- vim.keymap.set("n", "<S-Down>", "<C-d>")              -- Move cursor up on scroll up
-- vim.keymap.set("v", "<PageDown>", "<C-d>")            --
-- vim.keymap.set("i", "<PageDown>", "<C-O><C-d>")       --
vim.keymap.set("n", "<PageUp>", "30kzz")              -- Move cursor up on scroll up
vim.keymap.set("v", "<PageUp>", "30kzz")              --
vim.keymap.set("i", "<PageUp>", "<Esc>30kzzi")        --
vim.keymap.set("n", "<S-Up>", "30kzz")                --
vim.keymap.set("v", "<S-Up>", "30kzz")                --
vim.keymap.set("i", "<S-Up>", "<Esc>30kzzi")          --
vim.keymap.set("n", "<PageDown>", "30jzz")            -- Move cursor down on scroll down
vim.keymap.set("v", "<PageDown>", "30jzz")            --
vim.keymap.set("i", "<PageDown>", "<Esc>30jzzi")      --
vim.keymap.set("n", "<S-Down>", "30jzz")              --
vim.keymap.set("v", "<S-Down>", "30jzz")              --
vim.keymap.set("i", "<S-Down>", "<Esc>30jzzi")        --
vim.keymap.set("n", "n", "nzzzv")                     -- Next search centered
vim.keymap.set("n", "N", "Nzzzv")                     -- Previous search centered

vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")     -- Copy to system clipboard
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")     -- Delete without copying to clipboard

vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")           -- Quit terminal focus with Esc key
vim.keymap.set("n", "<D-Down>", ":m .+1<CR>==")       -- Move line up(n)
vim.keymap.set("n", "<D-Up>", ":m .-2<CR>==")         -- Move line down(n)
vim.keymap.set("v", "<D-Down>", ":m '>+1<CR>gv=gv")   -- Move line up(v)
vim.keymap.set("v", "<D-Up>", ":m '<-2<CR>gv=gv")     -- Move line down(v)
vim.keymap.set("i", "<D-Down>", "<ESC>:m .+1<CR>==i") -- Move line down(i)
vim.keymap.set("i", "<D-Up>", "<ESC>:m .-2<CR>==i")   -- Move line down(i)
vim.keymap.set("n", "Q", "<nop>")                     -- Disable repeat last macro
vim.keymap.set("n", "<leader>tr", ":tabprev<CR>")
vim.keymap.set("n", "<leader>tt", ":tabnext<CR>")
vim.keymap.set("n", "<C-s>", function() -- format and save file
    vim.lsp.buf.format()
    vim.cmd.write()
end, { remap = false })
vim.keymap.set("i", "<C-s>", function() -- format and save file
    vim.lsp.buf.format()
    vim.cmd.write()
end, { remap = false })
