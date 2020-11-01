local vim,lsp = vim,vim.lsp
local M = {}

-- coc error
local function diagnostic_coc_error()
  local has_info,info = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  if not has_info then return end
  if info.error > 0 then
    return info.error
  end
  return ''
end

-- coc warning
local function diagnostic_coc_warn()
  local has_info,info = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  if not has_info then return end
  if info.warning > 0 then
    return  info.warning
  end
  return ''
end

-- coc hint
local function diagnostic_coc_hint()
  local has_info,info = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  if not has_info then return end
  if info.hint > 0 then
    return  info.hint
  end
  return ''
end

-- coc info
local function diagnostic_coc_info()
  local has_info,info = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  if not has_info then return end
  if info.information > 0 then
    return  info.information
  end
  return ''
end

-- nvim-lspconfig
-- see https://github.com/neovim/nvim-lspconfig
local function diagnostic_nvim_lsp_error()
  if vim.tbl_isempty(lsp.buf_get_clients(0)) then return '' end
  local count = lsp.util.buf_diagnostics_count('Error')
  if count ~= 0 then return count end
end

-- nvim-lspconfig
-- see https://github.com/neovim/nvim-lspconfig
local function diagnostic_nvim_lsp_warn()
  if vim.tbl_isempty(lsp.buf_get_clients(0)) then return '' end
  local count = lsp.util.buf_diagnostics_count('Warning')
  if count ~= 0 then return count end
end

-- nvim-lspconfig
-- see https://github.com/neovim/nvim-lspconfig
local function diagnostic_nvim_lsp_hint()
  if vim.tbl_isempty(lsp.buf_get_clients(0)) then return '' end
  local count = lsp.util.buf_diagnostics_count('Hint')
  if count ~= 0 then return count end
end


-- nvim-lspconfig
-- see https://github.com/neovim/nvim-lspconfig
local function diagnostic_nvim_lsp_info()
  if vim.tbl_isempty(lsp.buf_get_clients(0)) then return '' end
  local count = lsp.util.buf_diagnostics_count('Information')
  if count ~= 0 then return count end
end

-- ale
-- see https://github.com/dense-analysis/ale
local function diagnostic_ale_error()
  local buf_nr = vim.fn.bufnr()
  local counts = vim.fn['ale#statusline#Count'](buf_nr)
  local error_counts = counts.error + counts.style_error
  return error_counts
end

-- ale
-- see https://github.com/dense-analysis/ale
local function diagnostic_ale_warn()
  local buf_nr = vim.fn.bufnr()
  local counts = vim.fn['ale#statusline#Count'](buf_nr)
  local non_error_counts = counts.total - (counts.error + counts.style_error)
  return non_error_counts
end


function M.get_diagnostic_error()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return diagnostic_coc_error()
  elseif vim.fn.exists('*ale#toggle#Enable') == 1 then
    return diagnostic_ale_error()
  elseif not vim.tbl_isempty(lsp.buf_get_clients(0)) then
    return diagnostic_nvim_lsp_error()
  end
  return ''
end

function M.get_diagnostic_warn()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return diagnostic_coc_warn()
  elseif vim.fn.exists('*ale#toggle#Enable') == 1 then
    return diagnostic_ale_warn()
  elseif not vim.tbl_isempty(lsp.buf_get_clients(0)) then
    return diagnostic_nvim_lsp_warn()
  end
  return ''
end

function M.get_diagnostic_hint()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return diagnostic_coc_hint()
  elseif not vim.tbl_isempty(lsp.buf_get_clients(0)) then
    return diagnostic_nvim_lsp_hint()
  end
  return ''
end

function M.get_diagnostic_info()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return diagnostic_coc_info()
  elseif not vim.tbl_isempty(lsp.buf_get_clients(0)) then
    return diagnostic_nvim_lsp_info()
  end
  return ''
end

return M
