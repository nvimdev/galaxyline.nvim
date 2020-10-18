local M = {}

function M.nvim_create_augroups(definition)
  vim.api.nvim_command('augroup galaxyline_user_event')
  vim.api.nvim_command('autocmd!')
  for _, def in ipairs(definition) do
    local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
    vim.api.nvim_command(command)
  end
  vim.api.nvim_command('augroup END')
end

return M
