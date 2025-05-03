-- Lualine
local function lualine_lspstatus()
  return require('lsp-progress').progress()
end

require("lsp-progress").setup()
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
    lualine_x = { 'copilot', 'diagnostics' },
    lualine_y = { 'branch', 'diff' },
    lualine_z = { 'filetype'},
  },
})

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "lualine_augroup",
  pattern = "LspProgressStatusUpdated",
  callback = require("lualine").refresh,
})
