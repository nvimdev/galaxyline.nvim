local common = require('galaxyline.common')

local get_lsp_client = function ()
  local buf_ft = vim.api.nvim_buf_get_option(0,'filetype')
  local buf_clients = vim.lsp.buf_get_clients()
  if next(buf_clients) == nil then
    return 'No Active Lsp'
  end
  for _,client in ipairs(buf_clients) do
    local filetypes = client.config.filetypes
    if filetypes and common.has_value(filetypes,buf_ft) then
      return client.name
    end
  end
  return 'No Active Lsp'
end

return {
  get_lsp_client = get_lsp_client
}
