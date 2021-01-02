local vim = vim
local M = {}

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
  LuaTree          = '  ',
}

function M.get_buffer_type_icon()
  return buf_icon[vim.bo.filetype]
end

function M.get_buffer_filetype()
  return vim.bo.filetype:upper()
end

-- get buffer number
function M.get_buffer_number()
  local buffers = {}
  for _,val in ipairs(vim.fn.range(1,vim.fn.bufnr('$'))) do
    if vim.fn.bufexists(val) == 1 and vim.fn.buflisted(val) == 1 then
      table.insert(buffers,val)
    end
  end

  for idx,nr in ipairs(buffers) do
    if nr == vim.fn.bufnr('') then
      return idx
    end
  end
end

return M
