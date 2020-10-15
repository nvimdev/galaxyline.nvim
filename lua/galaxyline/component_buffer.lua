local vim = vim
local M = {}

local function get_buffer_number()
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

function M.buffer_number()
  return get_buffer_number()
end


return M
