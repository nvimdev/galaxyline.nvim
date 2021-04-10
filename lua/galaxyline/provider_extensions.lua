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
  local has_vista,vista_info = pcall(vim.api.nvim_buf_get_var,0,'vista_nearest_method_or_function')
  if not has_vista then return end
  local icon = vista_icon or '✪ '
  return icon .. vista_info
end

-- extension for vimtex
-- show current mode
-- see https://github.com/lervag/vimtex
function M.vimtex_status(icon_main,icon_sub_main,icon_sub_local,icon_compiled,icon_continuous,icon_viewer,icon_none)
  local ic_main = icon_main or ''
  local ic_sub_main = icon_sub_main or 'm'
  local ic_sub_local = icon_sub_local or 'l'
  local ic_compiled = icon_compiled or 'c₁'
  local ic_continuous = icon_continuous or 'c'
  local ic_viewer = icon_viewer or 'v'
  local ic_none = icon_none or '0'

  local status = {}
  
  local has_vt_local,vt_local = pcall(vim.api.nvim_buf_get_var,0,'vimtex_local')
  if has_vt_local then
    if vt_local['active'] then
      table.insert(status,ic_sub_local)
    else
      table.insert(status,ic_sub_main)
    end
  else
    table.insert(status,ic_main)
  end

  local has_vt, vt = pcall(vim.api.nvim_buf_get_var,0,'vimtex')
  if has_vt then
    if vt['compiler'] then
      if vim.api.nvim_eval('b:vimtex.compiler.is_running()') == 1 then
        if vt['compiler']['continuous'] then
          table.insert(status,ic_continuous)
        else
          table.insert(status,ic_compiled)
        end
      end
    end
  end
  status = table.concat(status)
  if status == '' then
    status = ic_none
  end
  return status
end


return M
