local M = {}

function M.current_file_name()
  local file = vim.fn.expand('%:p')
  if vim.fn.empty(file) == 1 then return '' end
  return file
end

function M.format_file_size(file)
  local size = vim.fn.getfsize(file)
  if size == 0 or size == -1 or size == -2 then
    return ''
  end
  if size < 1024 then
    size = size .. 'b'
  elseif size < 1024 * 1024 then
    size = string.format('%f',size/1024.0) .. 'k'
  elseif size < 1024 * 1024 * 1024 then
    size = string.format('%f',size/1024.0/1024.0) .. 'm'
  else
    size = string.format('%f',size/1024.0/1024.0/1024.0) .. 'g'
  end
  return size
end

function M.get_file_size()
  local file = M.current_file_name()
  if vim.fn.empty(file) == 1 then return end
  return M.format_file_size(file)
end

function M.get_file_encode()
  local encode = vim.o.fenc ~= '' and vim.o.fenc or vim.o.enc
  return ' ' .. encode
end

function M.get_file_format()
  return vim.o.fileformat
end

function M.line_column()
  local line = vim.fn.line('.')
  local column = vim.fn.col('.')
  return line .. ':' .. column
end

function M.current_line_percent()
  local byte = vim.fn.line2byte(vim.fn.line('.')) + vim.fn.col('.') - 1
  local size = (vim.fn.line2byte(vim.fn.line('$') + 1) - 1)
  return (byte * 100) / size .. '%'
end

return M
