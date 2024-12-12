require("muhabi")
require("muhabi.remap")
require("muhabi.set")

-- Function to get the current Python virtual environment
local function get_venv()
    local venv = vim.fn.getenv('VIRTUAL_ENV')
    if venv ~= vim.NIL and venv ~= '' then
        -- Extract just the environment name from the full path
        local venv_name = vim.fn.fnamemodify(venv, ':t')
        return '🐍 ' .. venv_name
    else
        return ''
    end
end

-- Create custom statusline component for virtual environment
local function statusline_venv()
    local venv_info = get_venv()
    if venv_info ~= '' then
        return '%#PmenuSel# ' .. venv_info .. ' %#Normal#'
    end
    return ''
end

-- Set up autocmd to update statusline when entering a buffer
vim.api.nvim_create_autocmd({"BufEnter", "VimEnter"}, {
    pattern = "*",
    callback = function()
        -- Update statusline format
        vim.opt.statusline = table.concat({
            statusline_venv(),          -- Show virtual environment
            ' %f',                      -- File path
            '%m',                       -- Modified flag
            '%=',                       -- Separation between left and right aligned items
            '%y',                       -- File type
            ' %l,%c ',                 -- Line and column
            '%p%% '                    -- Percentage through file
        })
    end
})

-- Optional: Create a command to manually refresh the statusline
vim.api.nvim_create_user_command('RefreshEnv', function()
    vim.cmd('redrawstatus')
end, {})
