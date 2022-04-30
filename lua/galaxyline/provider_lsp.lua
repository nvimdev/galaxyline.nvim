local get_lsp_client = function (msg)
  msg = msg or 'No Active Lsp'
  local buf_ft = vim.api.nvim_buf_get_option(0,'filetype')
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end

  local client_name = ''
  for _,client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes,buf_ft) ~= -1 then
      client_name = client_name .. client.name .. ','
    end
  end
  local len = client_name:len()
  if len > 1 then
    return client_name:sub(0, len - 1)
  else
    return msg
  end
end

return {
  get_lsp_client = get_lsp_client
}
