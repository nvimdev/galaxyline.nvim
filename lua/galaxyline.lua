local vim = vim
local autocmd = require('galaxyline.common')
local diagnostic = require('galaxyline.provider_diagnostic')
local vimmode = require('galaxyline.provider_vim')
local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')
local extension = require('galaxyline.provider_extensions')
local colors = require('galaxyline.colors')
local M = {}

M.section = {}
M.section.left = require('section_test')[1]
M.section.right = require('section_test')[2]

local provider_group = {
  ShowVimMode = vimmode.show_vim_mode,
  DiagnosticError = diagnostic.diagnostic_error,
  DiagnosticWarn = diagnostic.diagnostic_warn,
  DiagnosticOk = diagnostic.diagnostic_ok,
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
        if #dynamicswitch ~= 0 then
          if dynamicswitch[component_name] ~= nil then
            return true,dynamicswitch[component_name]
          end
        end
      end
    end
  end
  return false,nil
end

local function exec_provider(icon,aliasby,cmd)
  local output
  if string.len(icon) ~= 0 then
    output = cmd()
    if string.len(output) ~= 0 then
      return icon .. cmd()
    end
  elseif vim.fn.empty(aliasby) == 0 then
    output = cmd()
    return aliasby[output]
  end
  return cmd()
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
  local aliasby = component_info.aliasby or {}
  if string.len(icon) ~= 0 and vim.fn.empty(aliasby) == 0 then
    print(string.format("Icon option and aliasby option can not be set at the same time in %s"),component_name)
    return
  end
  if type(provider) == 'string' then
    if provider_group[provider] == nil then
      print(string.format('Does not found the %s provider in default provider',component_name))
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
  local dynamicswitch = component_info.dynamicswitch or {}
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
  if #dynamicswitch == 0 then return tmp_line end
  for k,_ in pairs(dynamicswitch) do
    if string.len(M.component_decorator(k)) ~= 0 then
      tmp_line = generate_section(k)
      local separator = k.separator or ''
      if string.len(separator) ~= 0 then
        if position == 'left' then
          tmp_line = tmp_line .. generate_separator_section(separator)
        else
          tmp_line = generate_separator_section(separator) .. tmp_line
        end
      end
    end
  end
  return tmp_line
end

-- TODO: event
function M.load_galaxyline_autocmd()
  local au_event = {}
  local count = 0
  for pos,_ in pairs(M.section) do
    for _,component_info in pairs(M.section[pos]) do
      local event = component_info.event
      if event ~= nil and au_event[event] ~= 0 then
        au_event[event] = count + 1
      end
      local dynamicswitch = component_info.dynamicswitch or {}
      if #dynamicswitch ~= 0 then
        for _,j in pairs(dynamicswitch) do
          if j.event ~= nil and au_event[j.event] ~= 0 then
            au_event[j.event] = count + 1
          end
        end
      end
    end
  end
  autocmd.nvim_create_augroups(au_event)
end

function M.load_galaxyline()
  local left_section = ''
  local right_section = ''
  if M.section.left ~= nil then
    for _,component in pairs(M.section.left) do
      for component_name,component_info in pairs(component) do
        left_section = left_section .. section_complete_with_option(component_name,component_info,'left')
      end
    end
  end
  if M.section.right ~= nil then
    for _,component in pairs(M.section.right) do
      for component_name,component_info in pairs(component) do
        right_section = right_section .. section_complete_with_option(component_name,component_info,'right')
      end
    end
  end
  vim.o.statusline = left_section .. '%=' .. right_section
  colors.init_theme(get_section)
end

return M
