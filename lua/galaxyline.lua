local vim = vim
local diagnostic = require('galaxyline.component_diagnostic')
local vimmode = require('galaxyline.component_vim')
local autocmd = require('galaxyline.event')
local M = {}

-- section setup
M.section = {
  left = {
    ViMode = {
      command = 'ShowVimMode',
      separator = '',
      highlight = {'#008080','#fabd2f'},
      icon = {n = 'Normal'}
    },
    FileName = {
      -- command = require('some module').show_filename,
      separator = '',
    },
    DiagnosticError = {
      separator = '',
      icon = '',
    }
  };
  right = {
    FileInfo = {
      component = 'ShowFileInfo',
      separator = '',
      highlight = {'#008080','#fabd2f'},
    }
  }
}

local default_provider = {
  ShowVimMode = vimmode.show_vim_mode,
  DiagnosticError = diagnostic.diagnostic_error,
  DiagnosticWarn = diagnostic.diagnostic_warn,
  DiagnosticOk = diagnostic.diagnostic_ok,
}

local function check_component_exists(component_name)
  for k,v in pairs(M.section) do
    if v[component_name] ~= nil then
      return true,k
    end
  end
  return false,nil
end

-- component decorator
-- that will output the component result with icon
function M.component_decorator(component_name)
  -- if section doesn't have component just return
  local ok,position = check_component_exists(component_name)
  if not ok then return end
  local cmd = M.section[position][component_name].command or ''
  local icon = M.section[position][component_name].icon or ''
  if default_provider[cmd] ~= nil then
    if type(icon) == 'string' then
      return icon .. default_provider[cmd]()
    elseif type(icon) == 'table' then
      local output = default_provider[cmd]()
      return icon[output]
    end
  end
end

function M.build_line(component_name)
  local line = ''
  line = line .. '%#'..component_name..'#'
  line = line .. '%{luaeval(require("galaxyline").component_decorator,'..component_name..')()'.. '}'
  print(line)
  return line
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
