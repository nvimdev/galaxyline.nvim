local M = {}

-- return current background color
function M.get_background_color()
  local normal_bg = vim.fn.synIDattr(vim.fn.hlID('Normal'),'bg')
  if vim.fn.empty(normal_bg) then return 'NONE' end
  return normal_bg
end

local function set_highlight(group, color)
  local fg = color[1] and 'guifg=' .. color[1] or 'guifg=NONE'
  local bg = color[2] and 'guibg=' .. color[2] or 'guibg=NONE'
  vim.api.nvim_command('highlight ' .. group .. ' ' .. fg .. ' ' .. bg)
end

function M.init_theme(get_section)
  local section = get_section()
  for pos,_ in pairs(section) do
    for component_name,component_info in pairs(section[pos]) do
      local highlight = component_info.highlight or {}
      local separator_highlight = component_info.separator_highlight or {}
      set_highlight(component_name,highlight)

      if #separator_highlight ~= 0 then
        set_highlight(component_name..'Separator',separator_highlight)
      end

      local dynamicswitch = component_info.dynamicswitch or {}
      if #dynamicswitch ~= 0 then
        for i,j in pairs(dynamicswitch) do
          if j.highlight == nil then
            print(string.format("Wrong highlight value in component:%s",i))
            return
          end
          set_highlight(i,j.highlight)
          if j.separator_highlight ~= nil and #j.separator_highlight ~= 0 then
            set_highlight(i..'Separator', j.separator_highlight)
          end
        end
      end
    end
  end
end

return M
