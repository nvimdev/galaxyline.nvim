local vim = vim
local autocmd = require('galaxyline.event')
local diagnostic = require('galaxyline.provider_diagnostic')
local vimmode = require('galaxyline.provider_vim')
local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')
local colors = require('galaxyline.colors')
local M = {}
M.section = require('section_test')

local provider_group = {
  ShowVimMode = vimmode.show_vim_mode,
  DiagnosticError = diagnostic.diagnostic_error,
  DiagnosticWarn = diagnostic.diagnostic_warn,
  DiagnosticOk = diagnostic.diagnostic_ok,
  GitBranch = vcs.git_branch,
  DiffAdd = vcs.diff_add,
  DiffModified = vcs.diff_modified,
  DiffRemove = vcs.diff_remove,
  LineColumn = fileinfo.line_column,
  FileFormat = fileinfo.get_file_format,
  FileEncode = fileinfo.get_file_encode,
  FileSize = fileinfo.get_file_size,
  FIleIcon = fileinfo.get_file_icon,
  LinePercent = fileinfo.current_line_percent,
}

local function check_component_exists(component_name)
  for _,v in pairs(M.section) do
    if v[component_name] ~= nil then
      return true,v[component_name]
    end
    for _,j in pairs(v) do
      local dynamicswitch = j.dynamicswitch or {}
      if #dynamicswitch ~= 0 then
        if dynamicswitch[component_name] ~= nil then
          return true,dynamicswitch[component_name]
        end
      end
    end
  end
  return false,nil
end

local function exec_provider(icon,aliasby,cmd)
  if string.len(icon) ~= 0 then
    return icon .. cmd()
  elseif #aliasby ~= 0 then
    return aliasby[cmd()]
  end
end

-- component decorator
-- that will output the component result with icon
-- component provider and icon can be string or table
function M.component_decorator(component_name)
  -- if section doesn't have component just return
  local ok,component_info = check_component_exists(component_name)
  if not ok then
    print(string.format('Does not found this component: %s'),component_name)
    return
  end
  local provider = component_info.provider or ''
  local icon = component_info.icon or ''
  local aliasby = component_info.aliasby or {}
  if string.len(icon) ~= 0 and #aliasby ~= 0 then
    print(string.format("Icon option and aliasbyicon option can not be set at the same time in %s"),component_name)
    return
  end
  if type(provider) == 'string' then
    if provider_group[provider] == nil then
      print(string.format('Does not found the provider in default provider provider in %s'),component_name)
    end
    return exec_provider(icon,aliasby,provider_group[provider])
  elseif type(provider) == 'function' then
    return exec_provider(icon,aliasby,provider)
  elseif type(provider) == 'table' then
    local output = ''
    for _,v in pairs(provider) do
      if type(v) == 'string' then
        if provider_group[v] == nil then
          print(string.format('Does not found the provider in default provider provider in %s'),component_name)
          return
        end
        output = output + exec_provider(icon,aliasby,provider_group[provider])
      elseif type(v) == 'function' then
        output = output + exec_provider(icon,aliasby,provider)
      else
        print(string.format('Wrong provider type in %s'),component_name)
      end
    end
    return output
  end
end

function M.init_theme()
  for pos,_ in pairs(M.section) do
    for component_name,component_info in pairs(M.section[pos]) do
      local highlight = component_info.highlight
      if highlight ~= nil or type(highlight) ~= 'table' then
        print(string.format("Wrong highlight value in component:%s",component_name))
        return
      end
      colors.set_highlight(component_name,highlight)
      if component_info.separator ~= nil and #component_info.iconhighlight ~= 0 then
        colors.set_highlight(component_name..'Separator',component_info.iconhighlight)
      end
      local dynamicswitch = component_info.dynamicswitch or {}
      if #dynamicswitch ~= 0 then
        for i,j in pairs(dynamicswitch) do
          if j.highlight == nil then
            print(string.format("Wrong highlight value in component:%s",i))
            return
          end
          colors.set_highlight(i,j.highlight)
          if j.separator ~= nil and #j.iconhighlight ~= 0 then
            colors.set_highlight(i..'Separator',j.iconhighlight)
          end
        end
      end
    end
  end
end

local function generate_section(component_name)
  local line = ''
  line = line .. '%#'..component_name..'#'
  line = line .. '%{luaeval(require("galaxyline").component_decorator,'..component_name..')()'.. '}'
  return line
end

local function generate_separator_section(component_name,separator)
  local separator_name = component_name .. 'Separator'
  local line = ''
  line = line .. '%#'..separator_name..'#' .. separator
  return line
end


local function section_complete_with_option(component,component_info)
  local line = ''
  local emptyshow = component_info.emptyshow or true
  local dynamicswitch = component_info.dynamicswitch or {}
  if emptyshow then
    line = line .. generate_section(component)
    local separator = component_info.separator or ''
    if string.len(separator) ~= 0 then
      line = line .. generate_separator_section(component,separator)
    end
  else
    if string.len(M.component_decorator(component)) ~= 0 then
      line = line .. generate_section(component)
      local separator = component_info.separator or ''
      if string.len(separator) ~= 0 then
        line = line .. generate_separator_section(component,separator)
      end
    end
  end
  if #dynamicswitch == 0 then return line end
  for k,_ in pairs(dynamicswitch) do
    if string.len(M.component_decorator(k)) ~= 0 then
      line = generate_section(k)
      local separator = k.separator or ''
      if string.len(separator) ~= 0 then
        line = line .. generate_separator_section(separator)
      end
    end
  end
  return line
end

function M.load_galaxyline()
  local line = ''
  for component,component_info in pairs(M.section.left) do
    section_complete_with_option(component,component_info)
  end
  line = line .. '%='
  for component,component_info in pairs(M.section.right) do
    section_complete_with_option(component,component_info)
  end
  vim.o.statusline = line
  autocmd.galaxyline_augroups()
end

return M
