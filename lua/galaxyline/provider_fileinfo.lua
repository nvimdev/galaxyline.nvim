local vim = vim
local M = {}

-- get current file name
function M.current_file_name()
  local file = vim.fn.expand('%:p')
  if vim.fn.empty(file) == 1 then return '' end
  return file
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
    size = string.format('%f',size/1024.0) .. 'k'
  elseif size < 1024 * 1024 * 1024 then
    size = string.format('%f',size/1024.0/1024.0) .. 'm'
  else
    size = string.format('%f',size/1024.0/1024.0/1024.0) .. 'g'
  end
  return size
end

function M.get_file_size()
  local file = M.current_file_name()
  if vim.fn.empty(file) == 1 then return end
  return M.format_file_size(file)
end

-- get file encode
function M.get_file_encode()
  local encode = vim.o.fenc ~= '' and vim.o.fenc or vim.o.enc
  return ' ' .. encode
end

-- get file format
function M.get_file_format()
  return vim.o.fileformat
end

-- show line:column
function M.line_column()
  local line = vim.fn.line('.')
  local column = vim.fn.col('.')
  return line .. ':' .. column
end

-- show current line percent of all lines
function M.current_line_percent()
  local byte = vim.fn.line2byte(vim.fn.line('.')) + vim.fn.col('.') - 1
  local size = (vim.fn.line2byte(vim.fn.line('$') + 1) - 1)
  return (byte * 100) / size .. '%'
end

local icon_colors = {
   Brown        = '905532',
   Aqua         = '3AFFDB',
   Blue         = '689FB6',
   Darkblue     = '44788E',
   Purple       = '834F79',
   Red          = 'AE403F',
   Beige        = 'F5C06F',
   Yellow       = 'F09F17',
   Orange       = 'D4843E',
   Darkorange   = 'F16529',
   Pink         = 'CB6F6F',
   Salmon       = 'EE6E73',
   Green        = '8FAA54',
   Lightgreen   = '31B53E',
   White        = 'FFFFFF',
   LightBlue    = '5fd7ff',
}

local icons = {
    Brown        = {''},
    Aqua         = {''},
    LightBlue    = {''},
    Blue         = {'','','','','','','','','','','',''},
    Darkblue     = {'',''},
    Purple       = {'','','','','',''},
    Red          = {'','','','','',''},
    Beige        = {'','',''},
    Yellow       = {'','','λ','',''},
    Orange       = {''},
    Darkorange   = {'','','','',''},
    Pink         = {'',''},
    Salmon       = {''},
    Green        = {'','','','','',''},
    Lightgreen   = {'','',''},
    White        = {'','','','','',''},
}

function M.get_file_icon()
  local icon = ''
  if vim.fn.exists("*WebDevIconsGetFileTypeSymbol") == 1 then
    icon = vim.fn.WebDevIconsGetFileTypeSymbol()
    return icon
  end
  local ok,devicons = pcall(require,'nvim-web-devicons')
  if not ok then print('Does not found any icon plugin') return end
  local f_name,f_extension = vim.fn.expand('%:t'),vim.fn.expand('%:e')
  icon = devicons.get_icon(f_name,f_extension)
  if icon == nil then icon = '' end
  return icon
end

function M.get_file_icon_color()
  local icon = M.get_file_icon()
  for k,_ in pairs(icons) do
    if vim.fn.index(icons[k],icon) ~= -1 then
      return icon_colors[k]
    end
  end
end

return M
