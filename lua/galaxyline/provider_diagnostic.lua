local vim,lsp = vim,vim.lsp
local M = {}

function M.diagnostic_error()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    M.diagnostic_coc_error()
  elseif vim.fn.exists('*ale#toggle#Enable') == 1 then
    M.diagnostic_ale_error()
  elseif lsp.buf_get_clients(0) ~= nil then
    M.diagnostic_nvim_lsp_error()
  end
end

function M.diagnostic_warn()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    M.diagnostic_coc_warn()
  elseif vim.fn.exists('*ale#toggle#Enable') == 1 then
    M.diagnostic_ale_warn()
  elseif lsp.buf_get_clients(0) ~= nil then
    M.diagnostic_nvim_lsp_warn()
  end
end

function M.diagnostic_ok()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    M.diagnostic_coc_ok()
  elseif vim.fn.exists('*ale#toggle#Enable') ==1 then
    M.diagnostic_ale_ok()
  elseif lsp.buf_get_clients(0) ~= nil then
    M.diagnostic_nvim_lsp_ok()
  end
  return ''
end

-- coc error
function M.diagnostic_coc_error()
  local has_info,info = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  if not has_info then return end
  if vim.fn.empty(info) then return end
  if info.error > 0 then
    return info.error
  end
  return ''
end

-- coc warning
function M.diagnostic_coc_warn()
  local has_info,info = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  if not has_info then return end
  if vim.fn.empty(info) then return end
  if info.warning > 0 then
    return  info.warning
  end
  return ''
end

-- coc ok
function M.diagnostic_coc_ok()
  local has_info,info = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  if not has_info then return '' end
  if vim.fn.empty(info) then return '' end
  if info.warning == 0 and info.error == 0 then return '' end
end

-- nvim-lspconfig
-- see https://github.com/neovim/nvim-lspconfig
function M.diagnostic_nvim_lsp_error()
  if lsp.buf_get_clients(0) ~= 0 then return end
  local count = lsp.util.buf_diagnostics_count('Error')
  if count ~= 0 then return count end
end

-- nvim-lspconfig
-- see https://github.com/neovim/nvim-lspconfig
function M.diagnostic_nvim_lsp_warn()
  if lsp.buf_get_clients(0) ~= 0 then return end
  local count = lsp.util.buf_diagnostics_count('Warning')
  if count ~= 0 then return count end
end

-- nvim-lspconfig
-- see https://github.com/neovim/nvim-lspconfig
function M.diagnostic_nvim_lsp_ok()
  if lsp.buf_get_clients(0) ~= 0 then return end
  local error_count = lsp.util.buf_diagnostics_count('Error')
  local warn_count = lsp.util.buf_diagnostics_count('')
  if error_count == 0 and warn_count ==0 then return '' end
end

-- ale
-- see https://github.com/dense-analysis/ale
function M.diagnostic_ale_error()
  local buf_nr = vim.fn.bufnr()
  local counts = vim.fn['ale#statusline#Count'](buf_nr)
  local error_counts = counts.error + counts.style_error
  return error_counts
end

-- ale
-- see https://github.com/dense-analysis/ale
function M.diagnostic_ale_warn()
  local buf_nr = vim.fn.bufnr()
  local counts = vim.fn['ale#statusline#Count'](buf_nr)
  local non_error_counts = counts.total - (counts.error + counts.style_error)
  return non_error_counts
end

-- ale
-- see https://github.com/dense-analysis/ale
function M.diagnostic_ale_ok()
  local buf_nr = vim.fn.bufnr()
  local counts = vim.fn['ale#statusline#Count'](buf_nr)
  if counts.total == 0 then return '' end
end

return M
