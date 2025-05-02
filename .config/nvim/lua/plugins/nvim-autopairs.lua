return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    opts = {
        enable_check_bracket_line = false,
        ignored_next_char = "[%w%.]" -- will ignore alphanumeric and `.` symbol
    }
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
}
