
-- neo-tree
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
-- vim.lsp
local on_attach = function(_, bufnr)

  local bufmap = function(keys, func)
    vim.keymap.set('n', keys, func, { buffer = bufnr })
  end

  bufmap('<leader>r', vim.lsp.buf.rename)
  bufmap('<leader>a', vim.lsp.buf.code_action)

  bufmap('gd', vim.lsp.buf.definition)
  bufmap('gD', vim.lsp.buf.declaration)
  bufmap('gI', vim.lsp.buf.implementation)
  bufmap('<leader>D', vim.lsp.buf.type_definition)

  bufmap('gr', require('telescope.builtin').lsp_references)
  bufmap('<leader>s', require('telescope.builtin').lsp_document_symbols)
  bufmap('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols)

  bufmap('K', vim.lsp.buf.hover)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.config('*', {
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities),
})

vim.lsp.config('nil_ls', {
  cmd = { 'nil' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
  settings = {
    ['nil'] = {
      formatting = {
        command = { 'nixfmt' }
      }
    }
  }
})

vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh' },
})

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'cuda' }
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
})

vim.lsp.enable({'nil_ls', 'bashls', 'clangd', 'rust_analyzer'})

-- 全体設定
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
opt.expandtab = true
opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
--
opt.list = true
opt.listchars = { tab = '>>', trail = '-', nbsp = '+' }

keymap.set('n', ';', ':')
keymap.set('n', ':', ';')

keymap.set('n', '<leader>n', '<cmd>Neotree toggle<CR>')
keymap.set('n', '<leader>t', '<cmd>belowright new<CR><cmd>terminal<CR>')
