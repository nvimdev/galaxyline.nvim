function pconcat(tab)
  local ctab, n = {}, 1
  for k, _ in pairs(tab) do
      ctab[n] = k
      n = n + 1
  end
  return table.concat(ctab, ',')
end

local get_lsp_client = function (msg)
  msg = msg or 'No Active Lsp'
  local buf_ft = vim.api.nvim_buf_get_option(0,'filetype')
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end

  local tbl_names = {}
  for _,client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes,buf_ft) ~= -1 then
      tbl_names[client.name] = true
    end
  end

  client_name = pconcat(tbl_names)
  if client_name:len() > 0 then
    return client_name
  else
    return msg
  end
end

return {
  get_lsp_client = get_lsp_client
}
