-- optional settings for notifier
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Extra settings
vim.opt.clipboard = "unnamedplus" -- clipboard manager
vim.g.mapleader = "<Space>"
vim.opt.breakindent = true
vim.opt.mouse = "" -- disable mouse
vim.wo.relativenumber = true

-- Lazy.nvim
require("config.lazy")

-- Colorscheme
require("catppuccin").setup({
        flavour = "frappe",
})
vim.cmd.colorscheme "catppuccin"

-- bufferline
vim.opt.termguicolors = true

-- indent-blankline
require("ibl").setup()

require("bufferline").setup {
  options = {
    separator_style = "slant",
    offsets = {
                {
                    filetype = "NvimTree",
                    text = "NvimTree",
                    text_align = "left",
                    separator = true
                }
            },
  }
}

-- line numbering
vim.cmd([[set number]])

-- lualine
require('lualine').setup {
    options = {
        theme = "catppuccin",
    }
}

-- vim-notify
vim.opt.termguicolors = true

-- Bind CTRL + hjkl to change split buffer
vim.cmd([[
    nnoremap <silent> <C-l> <c-w>l
    nnoremap <silent> <C-h> <c-w>h
    nnoremap <silent> <C-k> <c-w>k
    nnoremap <silent> <C-j> <c-w>j
]])


-- nvim-tree
require("nvim-tree").setup({
    view = {
      width = 30
    },
    sync_root_with_cwd = true,
    update_focused_file = {
      enable = true
    },
    tab = {
      sync = {
        open = true,
      }
    }
})
local function open_nvim_tree(data)

  -- buffer is a real file on the disk
  local real_file = vim.fn.filereadable(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then-- and not no_name then
    return
  end

  -- open the tree, find the file but don't focus it
  require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- toggle nvim-tree
local function customNvimTreeToggle()
  local api= require("nvim-tree.api")

  -- change to directory
  local global_cwd = vim.fn.getcwd(-1, -1)
  api.tree.change_root(global_cwd)

  -- toggle tree
  api.tree.toggle({ focus = true, find_file = true})
end
vim.keymap.set('n', '<leader>e', customNvimTreeToggle)

-- auto close for nvim-tree
local function tab_win_closed(winnr)
  local api = require"nvim-tree.api"
  local tabnr = vim.api.nvim_win_get_tabpage(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local buf_info = vim.fn.getbufinfo(bufnr)[1]
  local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
  local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
  if buf_info.name:match(".*NvimTree_%d*$") then            -- close buffer was nvim tree
    -- Close all nvim tree on :q
    if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
      api.tree.close()
    end
  else                                                      -- else closed buffer was normal buffer
    if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
      local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
      if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
        vim.schedule(function ()
          if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
            vim.cmd "quit"                                        -- then close all of vim
          else                                                  -- else there are more tabs open
            vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
          end
        end)
      end
    end
  end
end

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function ()
    local winnr = tonumber(vim.fn.expand("<amatch>"))
    vim.schedule_wrap(tab_win_closed(winnr))
  end,
  nested = true
})

-- lsp-zero binds
vim.g.lsp_zero_extend_lspconfig = 0
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'pyright', 'lua_ls', 'html', 'jdtls'},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
    ["html"] = {
      enable_close = false
    }
  }
})

-- nvim-cmp
local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({behavior = 'select'}),
    ['<CR>'] = cmp.mapping.confirm({select = false})
  }
})

-- settings for tabs
vim.o.tabstop = 2 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2 -- Number of spaces inserted when indenting

-- vimtex
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_quickfix_open_on_warning = 0

-- cmp-vimtex
require('cmp').setup({
  sources = {
    { name = 'vimtex', },
  },
})

-- luasnip
require("luasnip.loaders.from_vscode").lazy_load()
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_format = require('lsp-zero').cmp_format({details = true})

require('luasnip.loaders.from_vscode').lazy_load()
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    ['<CR>'] = cmp.mapping.confirm({select = false}),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  --- (Optional) Show source name in completion menu
  formatting = cmp_format,
})
require("luasnip.loaders.from_lua").load({paths="~/snippets"})

-- bind <leader> + tab to :Telescope buffers
vim.keymap.set('n', '<LEADER><TAB>', ":Telescope buffers<CR>")
