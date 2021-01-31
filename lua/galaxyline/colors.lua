local M = {}

-- return current background color
function M.get_background_color()
  local normal_bg = vim.fn.synIDattr(vim.fn.hlID('Normal'),'bg')
  if vim.fn.empty(normal_bg) then return 'NONE' end
  return normal_bg
end

local function set_highlight(group, color)
  local fg,bg,style

  if type(color) == 'string' then
    vim.api.nvim_command('highlight link ' .. group .. ' ' .. color)
    return
  end

  if type(color[1]) == 'function' then
    local resolved_color = color[1]()
    if resolved_color ~= nil and resolved_color ~= "" then
      fg = 'guifg=' .. resolved_color
    else
      fg = 'guifg=NONE'
    end
  else
    fg = color[1] and 'guifg=' .. color[1] or 'guifg=NONE'
  end

  if type(color[2]) == 'function' then
    local resolved_color = color[2]()
    if resolved_color ~= nil and resolved_color ~= "" then
      bg = 'guibg=' .. resolved_color
    else
      bg = 'guibg=NONE'
    end
  else
    bg = color[2] and 'guibg=' .. color[2] or 'guibg=NONE'
  end

  if type(color[3]) == 'function' then
    style = 'gui='.. color[3]()
  else
    style = color[3] and 'gui=' .. color[3] or ' '
  end

  vim.api.nvim_command('highlight ' .. group .. ' ' .. fg .. ' ' .. bg .. ' '..style)
end

function M.init_theme(get_section)
  local section = get_section()
  for pos,_ in pairs(section) do
    for _,comps in pairs(section[pos]) do
      for component_name,component_info in pairs(comps) do
        local highlight = component_info.highlight or {}
        local separator_highlight = component_info.separator_highlight or {}
        set_highlight('Galaxy' .. component_name,highlight)

        if #separator_highlight ~= 0 then
          set_highlight(component_name..'Separator',separator_highlight)
        end

      end
    end
  end
end

return M
