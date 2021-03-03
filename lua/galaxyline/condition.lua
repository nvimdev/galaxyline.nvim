local M = {}

function M.buffer_not_empty()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

function M.check_git_workspace()
  local get_git_dir = require('galaxyline.provider_vcs').get_git_dir
  if vim.bo.buftype == 'terminal' then return false end
  local current_file = vim.fn.expand('%:p')
  local current_dir
  -- if file is a symlinks
  if vim.fn.getftype(current_file) == 'link' then
    local real_file = vim.fn.resolve(current_file)
    current_dir = vim.fn.fnamemodify(real_file,':h')
  else
    current_dir = vim.fn.expand('%:p:h')
  end
  local result = get_git_dir(current_dir)
  if not result then return false end
  return true
end

function M.hide_in_width()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

function M.check_active_lsp()
  local clients = vim.lsp.buf_get_clients()
  if next(clients) == nil then
    return false
  end
  return true
end

return M
