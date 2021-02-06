local api = vim.api
local M = {}

-- return current background color
function M.get_background_color()
  local normal_bg = vim.fn.synIDattr(vim.fn.hlID('Normal'),'bg')
  if vim.fn.empty(normal_bg) then return 'NONE' end
  return normal_bg
end

local _switch = {
  ['string'] = function (hi_type,hi_color)
    return 'gui'..hi_type..'='..hi_color
  end,
  ['function'] = function (hi_type,color)
    local resolved_color = color()
    if resolved_color == nil or resolved_color == "" then
      return 'gui'..hi_type..'='..'NONE'
    end
    return 'gui'..hi_type..'='..resolved_color
  end
}

local _switch_metatable = {
  __index = function (_,k)
    print(string.format("expect table or string got %s",type(k)))
    return
  end
}

setmetatable(_switch,_switch_metatable)

local function set_highlight(group, hi_info)
  local fg,bg,style = 'fg','bg',''

  if type(hi_info) == 'string' then
    api.nvim_command('highlight link ' .. group .. ' ' .. hi_info)
    return
  end

  if type(hi_info) == 'table' then
    fg = hi_info[1] and _switch[type(hi_info[1])](fg,hi_info[1]) or 'guifg=NONE'
    bg = hi_info[2] and _switch[type(hi_info[2])](bg,hi_info[2]) or 'guibg=NONE'
    style = hi_info[3] and  _switch[type(hi_info[3])](style,hi_info[3]) or ''
  end

  vim.api.nvim_command('highlight ' .. group .. ' ' .. fg .. ' ' .. bg .. ' '..style)
end

local send_section_color = function(section)
  return coroutine.create(function()
    for pos,_ in pairs(section) do
      for _,comps in pairs(section[pos]) do
        for component_name,component_info in pairs(comps) do
          if component_info.highlight then
            coroutine.yield('Galaxy' .. component_name,component_info.highlight)
          end
          if component_info.separator_highlight then
            coroutine.yield(component_name..'Separator',component_info.separator_highlight)
          end
        end
      end
    end
  end)
end

function M.init_theme(section)
  local producer = send_section_color(section)
  while true do
    local _,group,highlight = coroutine.resume(producer)
    if group and highlight then
      set_highlight(group,highlight)
    end
    if coroutine.status(producer) == 'dead' then
      break
    end
  end
end


return M
