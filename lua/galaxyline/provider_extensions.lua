local M = {}

-- extension for scoll bar
function M.scrollbar_instance(scroll_bar_chars)
  local current_line = vim.fn.line('.')
  local total_lines = vim.fn.line('$')
  local default_chars = {'__', '▁▁', '▂▂', '▃▃', '▄▄', '▅▅', '▆▆', '▇▇', '██'}
  local chars = scroll_bar_chars or default_chars
  local index = 1

  if  current_line == 1 then
    index = 1
  elseif current_line == total_lines then
    index = #chars
  else
    local line_no_fraction = vim.fn.floor(current_line) / vim.fn.floor(total_lines)
    index = vim.fn.float2nr(line_no_fraction * #chars)
    if index == 0 then
      index = 1
    end
  end
  return chars[index]
end

-- extension for vista.vim
-- show current function or method
-- see https://github.com/liuchengxu/vista.vim
function M.vista_nearest(vista_icon)
  local has_vista,vista_info = pcall(vim.fn.nvim_buf_get_var,0,'vista_nearest_method_or_function')
  if not has_vista then return end
  local icon = vista_icon or '✪'
  return icon .. vista_info
end

return M
