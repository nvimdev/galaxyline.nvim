local M = {}

-- return current background color
function M.get_background_color()
  local normal_bg = vim.fn.synIDattr(vim.fn.hlID('Normal'),'bg')
  if vim.fn.empty(normal_bg) then return 'NONE' end
  return normal_bg
end

function M.set_highlight(group, color)
    local fg = color[1] and 'guifg=' .. color[1] or 'guifg=NONE'
    local bg = color[2] and 'guibg=' .. color[2] or 'guibg=NONE'
    vim.api.nvim_command('highlight ' .. group .. ' ' .. fg .. ' ' .. bg)
end
return M
