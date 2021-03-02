local get_lsp_client = function ()
  local buf_clients = vim.lsp.buf_get_clients()
  if next(buf_clients) == nil then
    return 'No Actice Lsp '
  end
  for _,client in ipairs(buf_clients) do
    if client.filetypes[vim.bo.filetype] then
      return client.name ..' '
    end
  end
  return 'No Actice Lsp '
end

return {
  get_lsp_client = get_lsp_client
}
