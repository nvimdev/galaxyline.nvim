local M = {}
local helper = require('helper')

function M.diagnostic_coc_error()
  local has_info,info = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  local error_sign = helper.get_plugin_variable('diagnostic_error_sign','●')
  if not has_info then return end
  if vim.fn.empty(info) then return end
  if info.error > 0 then
    return error_sign .. info.error
  end
  return ''
end

function M.diagnostic_coc_warn()
  local has_info,info = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  local warn_sign = helper.get_plugin_variable('diagnostic_warn_sign','●')
  if not has_info then return end
  if vim.fn.empty(info) then return end
  if info.warning > 0 then
    return warn_sign .. info.warning
  end
  return ''
end

function M.diagnostic_coc_ok()
  local has_info,info = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  local ok_sign = helper.get_plugin_variable('diagnostic_ok_sign','')
  if not has_info then return ok_sign end
  if vim.fn.empty(info) then return ok_sign end
  if info.warning == 0 and info.error == 0 then return ok_sign end
end

function M.diagnostic_nvim_lsp_error()
end

function M.diagnostic_nvim_lsp_warn()
end

function M.diagnostic_nvim_lsp_ok()
end

function M.diagnostic_ale_error()
end

function M.diagnostic_ale_warn()
end

function M.diagnostic_ale_ok()
end

return M
