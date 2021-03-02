local get_lsp_client = function ()
  local buf_ft = api.nvim_buf_get_option(0,'filetype')
  local buf_clients = vim.lsp.buf_get_clients()
  if next(buf_clients) == nil then
    return 'No Actice Lsp '
  end
  for _,client in ipairs(buf_clients) do
    if client.config.filetypes and client.config.filetypes[buf_ft] then
      return client.name ..' '
    end
  end
  return 'No Actice Lsp '
end

return {
  get_lsp_client = get_lsp_client
}
