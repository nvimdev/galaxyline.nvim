local vim,lsp,api = vim,vim.lsp,vim.api
local M = {}

-- coc diagnostic
local function get_coc_diagnostic(diag_type)
  local has_info,info = pcall(vim.api.nvim_buf_get_var,0,'coc_diagnostic_info')
  if not has_info then return end
  return info[diag_type]
end

-- nvim-lspconfig
-- see https://github.com/neovim/nvim-lspconfig
local function get_nvim_lsp_diagnostic(diag_type)
  if next(lsp.buf_get_clients(0)) == nil then return '' end
  local active_clients = lsp.get_active_clients()

  if active_clients then
    local count = 0

    for _, client in ipairs(active_clients) do
       count = count + lsp.diagnostic.get_count(api.nvim_get_current_buf(),diag_type,client.id)
    end

    return count
  end
end

function M.get_diagnostic(diag_type)
  local count = 0

  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    count =  get_coc_diagnostic(diag_type:lower())
  elseif not vim.tbl_isempty(lsp.buf_get_clients(0)) then
    count = get_nvim_lsp_diagnostic(diag_type)
  end

  if count ~= 0 then return count end
end

local function get_formatted_diagnostic(diag_type)
  local count = M.get_diagnostic(diag_type)

  if count ~= nil then return count .. ' ' else return '' end
end

function M.get_diagnostic_error()
  return get_formatted_diagnostic('Error')
end

function M.get_diagnostic_warn()
  return get_formatted_diagnostic('Warning')
end

function M.get_diagnostic_hint()
  return get_formatted_diagnostic('Hint')
end

function M.get_diagnostic_info()
  return get_formatted_diagnostic('Information')
end

return M
