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

  if type(hi_info) == 'function' then
    hi_info = hi_info()
  end

  if hi_info == nil then return end

  if type(hi_info) == 'string' then
    api.nvim_command('highlight! link ' .. group .. ' ' .. hi_info)
    return
  end

  if type(hi_info) == 'table' then
    fg = hi_info[1] and _switch[type(hi_info[1])](fg,hi_info[1]) or 'guifg=NONE'
    bg = hi_info[2] and _switch[type(hi_info[2])](bg,hi_info[2]) or 'guibg=NONE'
    style = hi_info[3] and  _switch[type(hi_info[3])](style,hi_info[3]) or ''
  end

  vim.api.nvim_command('highlight ' .. group .. ' ' .. fg .. ' ' .. bg .. ' '..style)
end

function M.init_theme(hi_tbl)
  if next(hi_tbl) == nil then return end
  for group,hi_info in pairs(hi_tbl) do
    set_highlight(group,hi_info)
  end
end

return M
