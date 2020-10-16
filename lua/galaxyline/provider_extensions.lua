local M = {}
local helper = require('helper')

-- extension for scoll bar
function M.scrollbar_instance()
  local current_line = vim.fn.line('.') - 1
  local total_lines = vim.fn.line('$') - 1
  local default_value = {'▁', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'}
  local scroll_bar_chars = helper.get_plugin_variable('_scroll_bar_chars',default_value)
  local index = 0

  if current_line == 0 then
    index = 0
  elseif current_line == total_lines then
    index = -1
  else
    local line_no_fraction = vim.fn.floor(current_line) / vim.fn.floor(total_lines)
    index = vim.fn.float2nr(line_no_fraction * #scroll_bar_chars)
  end
  return scroll_bar_chars[index]
end

-- extension for vista.vim
-- show current function or method
-- see https://github.com/liuchengxu/vista.vim
function M.vista_nearest()
  local has_vista,vista_info = pcall(vim.fn.nvim_buf_get_var,0,'vista_nearest_method_or_function')
  if not has_vista then return end
  local vista_icon = helper.get_plugin_variable('_function_icon','✪')
  return vista_icon .. vista_info
end

return M
