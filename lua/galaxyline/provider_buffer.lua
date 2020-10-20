local vim = vim
local M = {}

-- get buffer number
function M.get_buffer_number()
  local num_bufs,idx = 0,1
  while (idx <= vim.fn.bufnr('$'))
  do
    if vim.fn.buflisted(idx) then
      num_bufs = num_bufs + 1
    end
    idx = idx + 1
  end
  return num_bufs
end

local buf_icon = {
  help             = '  ',
  defx             = '  ',
  nerdtree         = '  ',
  denite           = '  ',
  ['vim-plug']     = '  ',
  vista            = ' 識',
  vista_kind       = '  ',
  dbui             = '  ',
  magit            = '  ',
}

function M.get_buffer_type_icon()
  return buf_icon[vim.bo.filetype]
end

function M.get_buffer_filetype()
  return vim.bo.filetype:upper()
end

return M
