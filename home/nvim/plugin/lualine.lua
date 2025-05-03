-- Lualine
local function lualine_lspstatus()
  local icon = 'LSP:'
  local msg = 'No Active'
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local clients = vim.lsp.get_clients()
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
    lualine_x = { 'copilot', 'diagnostics' },
    lualine_y = { 'branch', 'diff' },
    lualine_z = { 'filetype'},
  },
})
