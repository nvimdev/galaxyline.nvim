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
M.section.left = require('section_test')[1]
M.section.right = require('section_test')[2]
M.section.short_line_left = require('section_test')[3]
M.section.short_line_right = require('section_test')[4]

local provider_group = {
  BufferIcon  = buffer.get_buffer_type_icon,
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
        if provider_group[v] == nil then
          print(string.format('Does not found the provider in default provider provider in %s'),component_name)
          return
        end
        output = output + exec_provider(icon,provider_group[provider])
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
  line = line .. '%#'..component_name..'#'
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
  -- get the component condition and dynamicswitch
  local condition = component_info.condition or nil
  local dynamicswitch = component_info["dynamicswitch"] or {}
  if condition ~= nil then
    if condition() then
      tmp_line = tmp_line .. generate_section(component)
      local separator = component_info.separator or ''
      if string.len(separator) ~= 0 then
        if position == 'left' then
          tmp_line = tmp_line .. generate_separator_section(component,separator)
        else
          tmp_line = generate_separator_section(component,separator) .. tmp_line
        end
      end
      if next(dynamicswitch) ~= nil then
        for k,_ in pairs(dynamicswitch) do
          local output = M.component_decorator(k)
          if string.len(output) ~= nil and string.len(output) ~= 0 then
            tmp_line = generate_separator_section(component,separator)
          end
        end
      end
    end
  else
    tmp_line = tmp_line .. generate_section(component)
    local separator = component_info.separator or ''
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

function M.galaxyline_short_line()
end

function M.load_galaxyline()
  local left_section = ''
  local right_section = ''
  local short_left_section = ''
  local short_right_section = ''
  if M.section.left ~= nil then
    for _,component in pairs(M.section.left) do
      for component_name,component_info in pairs(component) do
        local ls = section_complete_with_option(component_name,component_info,'left')
        left_section = left_section .. ls
      end
    end
  end
  if M.section.right ~= nil then
    for _,component in pairs(M.section.right) do
      for component_name,component_info in pairs(component) do
        local rs = section_complete_with_option(component_name,component_info,'right')
        right_section = right_section .. rs
      end
    end
  end
  if M.section.short_line_left ~= nil then
    for _,component in pairs(M.section.short_line_left) do
      for component_name,component_info in pairs(component) do
        local ls = section_complete_with_option(component_name,component_info,'left')
        short_left_section = short_left_section .. ls
      end
    end
  end
  if M.section.short_line_right ~= nil then
    for _,component in pairs(M.section.short_line_right) do
      for component_name,component_info in pairs(component) do
        local rs = section_complete_with_option(component_name,component_info,'right')
        short_right_section = short_right_section .. rs
      end
    end
  end
  local list = {'defx','coc-explorer','dbui','vista','vista_markdown','Mundo','MundoDiff'}
  if common.has_value(list,vim.bo.filetype) then
    vim.o.statusline = short_left_section .. '%=' .. short_right_section
  else
    vim.o.statusline = left_section .. '%=' .. right_section
  end
  colors.init_theme(get_section)
end

return M
