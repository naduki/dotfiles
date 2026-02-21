
--------------------------------------------------------------------------------
-- General Settings
--------------------------------------------------------------------------------
local opt = vim.opt
local g = vim.g

-- UI / Appearance
vim.cmd.colorscheme('poimandres')
opt.termguicolors = true
opt.number = true
opt.signcolumn = 'yes'
opt.cursorline = true
opt.list = true
opt.listchars = { tab = '>>', trail = '-', nbsp = '+' }

-- Editing / Indent
opt.updatetime = 300
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true
opt.clipboard = 'unnamedplus'
opt.mouse = 'a'
opt.swapfile = false

g.mapleader = ' '
g.maplocalleader = ' '

-- Disable Netrw (using neo-tree)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Disable Providers
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter", "BufEnter" }, {
  pattern = "*",
  callback = function()
    vim.fn.system("fcitx5-remote -c")
  end,
})

--------------------------------------------------------------------------------
-- Keymaps (General)
--------------------------------------------------------------------------------
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', ':', ';')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

--------------------------------------------------------------------------------
-- Plugin Configurations
--------------------------------------------------------------------------------

-- nvim-autopairs
require("nvim-autopairs").setup {}

-- gitsigns
require('gitsigns').setup {}

-- which-key
local wk = require("which-key")
wk.setup({})

wk.add({
  { "<leader>f", group = "file/find" },
  { "<leader>s", group = "search/symbol" },
})

-- neo-tree
require("neo-tree").setup({
  filesystem = {
    follow_current_file = { enabled = true },
    hijack_netrw_behavior = "open_current",
    use_libuv_file_watcher = true,
    filtered_items = {
      visible = false,
      show_hidden_count = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = { "thumbs.db", ".envrc" },
      never_show = { ".git", ".DS_Store", ".direnv" },
    },
  },
})
vim.keymap.set('n', '<leader>n', '<cmd>Neotree toggle<CR>')

-- telescope
require('telescope').setup({
  extensions = {
    fzf = {
      fuzzy = true,                     -- false will only do exact matching
      override_generic_sorter = true,   -- override the generic sorter
      override_file_sorter = true,      -- override the file sorter
      case_mode = "smart_case",         -- or "ignore_case" or "respect_case"
                                        -- the default case_mode is "smart_case"
    }
  }
})

require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')

local function lsp_keymaps(bufnr)
  local bufmap = function(keys, func)
    vim.keymap.set('n', keys, func, { buffer = bufnr })
  end

  -- Telescope integration
  bufmap('grr', builtin.lsp_references)
  bufmap('<leader>s', builtin.lsp_document_symbols)
  bufmap('<leader>S', builtin.lsp_dynamic_workspace_symbols)
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    lsp_keymaps(event.buf)

    -- Format command
    vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
      vim.lsp.buf.format()
    end, {})
  end,
})

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- lualine & lsp-progress
require("lsp-progress").setup()
require("lualine").setup({
  icons_enabled = true,
  theme = 'poimandres',
  options = { globalstatus = true },
  section_separators = { left = '', right = '' },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'filename', newfile_status = true, path = 1, shorting_target = 24 },
    },
    lualine_c = { 
      function()
        return require('lsp-progress').progress()
      end,
    },
    lualine_x = { 'diagnostics' },
    lualine_y = { 'branch', 'diff' },
    lualine_z = { 'filetype' },
  },
})

-- Listen lsp-progress event
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("lualine_augroup", { clear = true }),
  pattern = "LspProgressStatusUpdated",
  callback = require("lualine").refresh,
})

-- nvim-cmp & luasnip
local cmp = require('cmp')
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-a>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }) -- Prefer selection over snippet
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- toggleterm
require("toggleterm").setup({
  size = 10, 
  open_mapping = [[<c-\>]],
  direction = 'horizontal',
  shell = "fish",
  start_in_insert = true,
  persist_size = true,
})

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- Enable these keymaps only when a terminal is opened
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

--------------------------------------------------------------------------------
-- LSP Configuration
--------------------------------------------------------------------------------
-- Capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup servers
local servers = {
  bashls = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'sh' },
  },
  clangd = {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'cuda' },
    root_markers = { '.clangd', 'compile_commands.json', 'compile_flags.txt' },
  },
  nixd = {
    cmd = { 'nixd' },
    settings = { nixd = { formatting = { command = { 'nixfmt' } } } },
    root_markers = { 'flake.nix' },
    filetypes = { 'nix' },
  },
  pyright = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
        },
      },
    },
  },
  rust_analyzer = {
    cmd = { 'rust-analyzer' },
    settings = { ['rust-analyzer'] = { diagnostics = { enable = false } } },
    filetypes = { 'rust' },
  },
  texlab = {
    cmd = { 'texlab' },
    filetypes = { 'tex', 'bib' },
  },
}

for name, conf in pairs(servers) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = conf.filetypes,
    callback = function(args)
      local root_markers = conf.root_markers or { '.git' }
      local root_dir = vim.fs.root(args.buf, root_markers) or vim.uv.cwd()

      vim.lsp.start({
        name = name,
        cmd = conf.cmd,
        root_dir = root_dir,
        settings = conf.settings,
        capabilities = capabilities,
      })
    end,
  })
end

-- Diagnostic UI
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

--------------------------------------------------------------------------------
-- Treesitter (Native/Manual)
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NativeTreesitter", { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if not lang then return end

    -- Safe check for parser availability
    local has_parser = pcall(function() vim.treesitter.get_parser(args.buf, lang) end)
    if has_parser then
      vim.treesitter.start(args.buf, lang)
    end
  end,
})

-- Folding & Indent (Experimental)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99
opt.indentexpr = "v:lua.vim.treesitter.indentexpr()"

-- Gemini Launch
vim.keymap.set('n', '<leader>l', function()
  vim.cmd('lcd %:p:h')
  vim.cmd('botright 80vsplit | terminal gemini')
  vim.cmd('startinsert')
end, { desc = 'Launch Gemini CLI' })

-- Gemini Terminal Specific Settings
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  pattern = "term://*gemini",
  callback = function()
    -- Disable <esc> to normal mode for Gemini CLI
    pcall(vim.keymap.del, 't', '<esc>', { buffer = 0 })
    
    if vim.bo.buftype == 'terminal' then
      vim.cmd('startinsert')
    end
  end,
})
