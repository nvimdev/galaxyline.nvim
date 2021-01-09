local vim = vim
local M = {}

local function file_readonly()
  if vim.bo.filetype == 'help' then
    return ''
  end
  if vim.bo.readonly == true then
    return " "
  end
  return ''
end

-- get current file name
function M.get_current_file_name()
  local file = vim.fn.expand('%:t')
  if vim.fn.empty(file) == 1 then return '' end
  if string.len(file_readonly()) ~= 0 then
    return file .. file_readonly()
  end
  if vim.bo.modifiable then
    if vim.bo.modified then
      return file .. '   '
    end
  end
  return file .. ' '
end

-- format print current file size
function M.format_file_size(file)
  local size = vim.fn.getfsize(file)
  if size == 0 or size == -1 or size == -2 then
    return ''
  end
  if size < 1024 then
    size = size .. 'b'
  elseif size < 1024 * 1024 then
    size = string.format('%.1f',size/1024) .. 'k'
  elseif size < 1024 * 1024 * 1024 then
    size = string.format('%.1f',size/1024/1024) .. 'm'
  else
    size = string.format('%.1f',size/1024/1024/1024) .. 'g'
  end
  return size .. ' '
end

function M.get_file_size()
  local file = vim.fn.expand('%:p')
  if string.len(file) == 0 then return '' end
  return M.format_file_size(file)
end

-- get file encode
function M.get_file_encode()
  local encode = vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc
  return ' ' .. encode
end

-- get file format
function M.get_file_format()
  return vim.bo.fileformat
end

-- show line:column
function M.line_column()
  local line = vim.fn.line('.')
  local column = vim.fn.col('.')
  return line .. ':' .. column
end

-- show current line percent of all lines
function M.current_line_percent()
  local current_line = vim.fn.line('.')
  local total_line = vim.fn.line('$')
  if current_line == 1 then
    return ' Top '
  elseif current_line == vim.fn.line('$') then
    return ' Bot '
  end
  local result,_ = math.modf((current_line/total_line)*100)
  return ' '.. result .. '% '
end

local icon_colors = {
   Brown        = '#905532',
   Aqua         = '#3AFFDB',
   Blue         = '#689FB6',
   Darkblue     = '#44788E',
   Purple       = '#834F79',
   Red          = '#AE403F',
   Beige        = '#F5C06F',
   Yellow       = '#F09F17',
   Orange       = '#D4843E',
   Darkorange   = '#F16529',
   Pink         = '#CB6F6F',
   Salmon       = '#EE6E73',
   Green        = '#8FAA54',
   Lightgreen   = '#31B53E',
   White        = '#FFFFFF',
   LightBlue    = '#5fd7ff',
}

local icons = {
    Brown        = {''},
    Aqua         = {''},
    LightBlue    = {'',''},
    Blue         = {'','','','','','','','','','','','',''},
    Darkblue     = {'',''},
    Purple       = {'','','','',''},
    Red          = {'','','','','',''},
    Beige        = {'','',''},
    Yellow       = {'','','λ','',''},
    Orange       = {'',''},
    Darkorange   = {'','','','',''},
    Pink         = {'',''},
    Salmon       = {''},
    Green        = {'','','','','',''},
    Lightgreen   = {'','','','﵂'},
    White        = {'','','','','',''},
}

-- filetype or extensions : { colors ,icon}
local user_icons = {}

function M.define_file_icon()
  return  user_icons
end

function M.get_file_icon()
  local icon = ''
  if vim.fn.exists("*WebDevIconsGetFileTypeSymbol") == 1 then
    icon = vim.fn.WebDevIconsGetFileTypeSymbol()
    return icon .. ' '
  end
  local ok,devicons = pcall(require,'nvim-web-devicons')
  if not ok then print('No icon plugin found. Please install \'kyazdani42/nvim-web-devicons\'') return '' end
  local f_name,f_extension = vim.fn.expand('%:t'),vim.fn.expand('%:e')
  icon = devicons.get_icon(f_name,f_extension)
  if icon == nil then
    if user_icons[vim.bo.filetype] ~= nil then
      icon = user_icons[vim.bo.filetype][2]
    elseif user_icons[f_extension] ~= nil then
      icon = user_icons[f_extension][2]
    else
      icon = ''
    end
  end
  return icon .. ' '
end

function M.get_file_icon_color()
  local icon = M.get_file_icon():match('%S+')
  local filetype = vim.bo.filetype
  local f_ext = vim.fn.expand('%:e')
  if user_icons[filetype] == nil and user_icons[f_ext] == nil then
    for k,_ in pairs(icons) do
      if vim.fn.index(icons[k],icon) ~= -1 then
        return icon_colors[k]
      end
    end
  elseif user_icons[filetype] ~= nil then
    return user_icons[filetype][1]
  elseif user_icons[f_ext] ~= nil then
    return user_icons[f_ext][1]
  end
end

return M
