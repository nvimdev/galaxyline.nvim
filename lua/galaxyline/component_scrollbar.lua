local M = {}
local helper = require('helper')

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

return M
