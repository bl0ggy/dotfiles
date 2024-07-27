require("thejs")
-- Set working dir to the current dir at startup (e.g. `nvim subfolder` sets the working to 'subfolder' instead of '.')

local isDir = vim.fn.isdirectory(vim.api.nvim_buf_get_name(0))
if isDir == 1 then
    vim.cmd(":cd" .. vim.api.nvim_buf_get_name(0))
end
