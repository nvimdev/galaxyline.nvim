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
  LinePercent = fileinfo.current_line_percent,
}

local function check_component_exists(component_name)
  for k,v in pairs(M.section) do
    if v[component_name] ~= nil then
      return true,k
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
  local ok,position = check_component_exists(component_name)
  if not ok then
    print(string.format('Does not found this component: %s'),component_name)
    return
  end
  local provider = M.section[position][component_name].provider or ''
  local icon = M.section[position][component_name].icon or ''
  local aliasby = M.section[position][component_name].aliasby or {}
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

function M.build_line(component_name)
  local line = ''
  line = line .. '%#'..component_name..'#'
  line = line .. '%{luaeval(require("galaxyline").component_decorator,'..component_name..')()'.. '}'
  print(line)
  return line
end

function M.init_theme(component_name)
  local ok,pos = check_component_exists(component_name)
  if not ok then
    print(string.format('Does not found this component: %s'),component_name)
    return
  end
  local hi_group = {}
  colors = M.section[pos][component_name].highlight or {}
  if type(colors) == 'function' then
    hi_group[1],hi_group[2] = colors()
  elseif type(colors) == 'table' then
    hi_group = colors
  end
  colors.set_highlight(component_name,hi_group)
end

function M.load_galaxyline()
  local line = ''
  for key,_ in pairs(M.section.left) do
    line = line .. M.build_line(key)
  end
  line = line .. '%='
  for key,_ in pairs(M.section.right) do
    line = line .. M.build_line(key)
  end
  vim.o.statusline = line
  autocmd.galaxyline_augroups()
end

return M
