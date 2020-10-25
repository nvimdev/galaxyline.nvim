local vim = vim
local common = require('galaxyline.common')
local diagnostic = require('galaxyline.provider_diagnostic')
local vimmode = require('galaxyline.provider_vim')
local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')
local extension = require('galaxyline.provider_extensions')
local colors = require('galaxyline.colors')
local buffer = require('galaxyline.provider_buffer')
local M = {}

M.section = {}
M.section.left = {}
M.section.right = {}
M.section.short_line_left = {}
M.section.short_line_right = {}
M.short_line_list = {}

local provider_group = {
  BufferIcon  = buffer.get_buffer_type_icon,
  BufferNumber = buffer.get_buffer_number,
  FileTypeName = buffer.get_buffer_filetype,
  ShowVimMode = vimmode.show_vim_mode,
  GitBranch = vcs.get_git_branch,
  DiffAdd = vcs.diff_add,
  DiffModified = vcs.diff_modified,
  DiffRemove = vcs.diff_remove,
  LineColumn = fileinfo.line_column,
  FileFormat = fileinfo.get_file_format,
  FileEncode = fileinfo.get_file_encode,
  FileSize = fileinfo.get_file_size,
  FileIcon = fileinfo.get_file_icon,
  FileName = fileinfo.get_current_file_name,
  LinePercent = fileinfo.current_line_percent,
  ScrollBar = extension.scrollbar_instance,
  VistaPlugin = extension.vista_nearest,
  DiagnosticError = diagnostic.get_diagnostic_error,
  DiagnosticWarn = diagnostic.get_diagnostic_warn,
}

local function get_section()
  return M.section
end

local function check_component_exists(component_name)
  for _,pos_value in pairs(M.section) do
    for _,v in pairs(pos_value) do
      if v[component_name] ~= nil then
        return true,v[component_name]
      end
      for _,j in pairs(v) do
        local dynamicswitch = j.dynamicswitch or {}
        if next(dynamicswitch) ~= nil then
          if dynamicswitch[component_name] ~= nil then
            return true,dynamicswitch[component_name]
          end
        end
      end
    end
  end
  return false,nil
end

local function exec_provider(icon,cmd)
  local output = cmd()
  if output == nil then return '' end
  if string.len(icon) ~= 0 and string.len(output) ~= 0 and output then
    return icon .. cmd()
  end
  return output
end

-- component decorator
-- that will output the component result with icon
-- component provider and icon can be string or table
function M.component_decorator(component_name)
  -- if section doesn't have component just return
  local ok,component_info = check_component_exists(component_name)
  if not ok then
    print(string.format('Does not found this component: %s',component_name))
    return
  end
  local provider = component_info.provider or ''
  local icon = component_info.icon or ''
  if type(provider) == 'string' then
    if provider_group[provider] == nil then
      print(string.format('The provider of %s does not exist in default provider group',component_name))
      return
    end
    return exec_provider(icon,provider_group[provider])
  elseif type(provider) == 'function' then
    return exec_provider(icon,provider)
  elseif type(provider) == 'table' then
    local output = ''
    for _,v in pairs(provider) do
      if type(v) == 'string' then
        if type(provider_group[v]) ~= 'function' then
          print(string.format('Does not found the provider in default provider provider in %s',component_name))
          return
        end
        output = output .. exec_provider(icon,provider_group[v])
      elseif type(v) == 'function' then
        output = output + exec_provider(icon,provider)
      else
        print(string.format('Wrong provider type in %s'),component_name)
      end
    end
    return output
  end
end

local function generate_section(component_name)
  local line = ''
  line = line .. '%#'..'Galaxy'.. component_name..'#'
  line = line .. [[%{luaeval('require("galaxyline").component_decorator')]]..'("'..component_name..'")}'
  return line
end

local function generate_separator_section(component_name,separator)
  local separator_name = component_name .. 'Separator'
  local line = ''
  line = line .. '%#'..separator_name..'#' .. separator
  return line
end

local function section_complete_with_option(component,component_info,position)
  local tmp_line = ''
  local dyan_line = ''
  Target = false
  -- get the component condition and dynamicswitch
  local condition = component_info.condition or nil
  local dynamicswitch = component_info["dynamicswitch"] or {}
  local separator = component_info.separator or ''
  if condition ~= nil then
    if condition() then
      tmp_line = tmp_line .. generate_section(component)
      if next(dynamicswitch) ~= nil then
        for k,v in pairs(dynamicswitch) do
          if type(v.provider) ~= 'function' then
            print(string.format('%s dynamicswitch only support function provider',component))
            return
          end
          if v.provider() ~= nil and string.len(v.provider()) > 0 then
            Target = true
            dyan_line = dyan_line .. generate_section(k)
          end
        end
      end
      if string.len(separator) ~= 0 then
        if position == 'left' then
          tmp_line = tmp_line .. generate_separator_section(component,separator)
          dyan_line = dyan_line .. generate_separator_section(component,separator)
        else
          tmp_line = generate_separator_section(component,separator) .. tmp_line
          dyan_line = generate_separator_section(component,separator) .. dyan_line
        end
    end
    end
    if Target == true then
      return dyan_line
    end
    return tmp_line
  else
    tmp_line = tmp_line .. generate_section(component)
    if string.len(separator) ~= 0 then
      if position == 'left' then
        tmp_line = tmp_line .. generate_separator_section(component,separator)
      else
        tmp_line = generate_separator_section(component,separator) .. tmp_line
      end
    end
  end
  return tmp_line
end

local function load_section(section_area,pos)
  local section = ''
  if section_area ~= nil then
    for _,component in pairs(section_area) do
      for component_name,component_info in pairs(component) do
        local ls = section_complete_with_option(component_name,component_info,pos)
        section = section .. ls
      end
    end
  end
  return section
end

function M.inactive_galaxyline()
  local combin = function ()
    local short_left_section = load_section(M.section.short_line_left,'left')
    local short_right_section = load_section(M.section.short_line_right,'right')
    local line = short_left_section .. '%=' .. short_right_section
    return line
  end
  vim.wo.statusline = combin()
end

function M.load_galaxyline()
  local combination = function()
    local left_section = load_section(M.section.left,'left')
    local right_section = load_section(M.section.right,'right')
    local short_left_section = load_section(M.section.short_line_left,'left')
    local short_right_section = load_section(M.section.short_line_right,'right')
    if common.has_value(M.short_line_list,vim.bo.filetype) then
      return short_left_section .. '%=' .. short_right_section
    else
      return  left_section .. '%=' .. right_section
    end
  end
  vim.wo.statusline = combination()
  colors.init_theme(get_section)
end

return M
