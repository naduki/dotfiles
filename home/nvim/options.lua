
-- Lualine
local function lualine_lspstatus()
    local icon = 'LSP:'
    local msg = 'No Active'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return icon .. msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return icon .. client.name
      end
    end
    return icon .. msg
end

require("lualine").setup({
    icons_enabled = true,
    theme = 'poimandres',
    options = {
        globalstatus = true,
    },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {},
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          {
            'filename',
            newfile_status = true,
            path = 1,
            shorting_target = 24,
          },
        },
        lualine_c = { lualine_lspstatus },
        lualine_x = { 'diagnostics' },
        lualine_y = { 'branch', 'diff' },
        lualine_z = { 'filetype'},
    },
})

require("neo-tree").setup({
    filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        filtered_items = {
            visible = false, -- デフォルトで隠されているかどうか
            show_hidden_count = true,
            hide_dotfiles = false, -- dotfileを隠すかどうか
            hide_gitignored = false, -- gitignoreされているファイルを隠すかどうか
            hide_by_name = {
                "node_modules",
                "thumbs.db",
            },
            never_show = {
                ".git",
                ".DS_Store",
                ".history",
            },
        },
    },
})

local g = vim.g
local o = vim.o
local opt = vim.opt
local keymap = vim.keymap

g.mapleader = ' '
g.maplocalleader = ' '

o.clipboard = 'unnamedplus'

o.number = true
-- o.relativenumber = true

o.signcolumn = 'yes'

o.updatetime = 300

o.termguicolors = true

o.mouse = 'a'

-- Disable Netrw
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
-- tmpfile
opt.swapfile = false
-- indent
opt.autoindent = true
opt.smartindent = true
-- highlight
opt.cursorline = true
-- tab, indent
opt.tabstop = 4
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
--
opt.list = true
opt.listchars = { tab = '>>', trail = '-', nbsp = '+' }

keymap.set('n', ';', ':')
keymap.set('n', ':', ';')

keymap.set('n', '<leader>n', '<cmd>Neotree toggle<CR>')
keymap.set('n', '<leader>t', '<cmd>belowright new<CR><cmd>terminal<CR>')
