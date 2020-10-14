local vim = vim
local autocmd = require('galaxyline.event')
local M = {}

local function get_default_component(component_name)
  local default_component = {
    ShowVimMode = 'require("galaxyline.component").show_vim_mode',
  }
  return default_component[component_name]
end

function M.build_line(component_name,component_info)
  local line = ''
  local cmd = component_info[command] or ''
  line = line .. '%#'..component_name..'#'
  if get_default_component(cmd) ~= nil then
    cmd = get_default_component(cmd)
  end
  line = line .. '%{luaeval('..'"'..cmd..'")()'
  return line
end

function M.setup(opts)
  local line = ''
  for key,value in pairs(opts[left]) do
    line = M.build_line(key,value)
  end
  line = line .. '%='
  for key,value in pairs(opts[right]) do
    line = M.build_line(key,value)
  end
  vim.o[statusline] = line
  autocmd.galaxyline_augroups()
end

-- Test data
local section = {
  left = {
    ViMode = {
      command = 'ShowVimMode',
      separator = '',
      highlight = {'#008080','#fabd2f'},
    },
    FileName = {
      command = "require('xxx').show_filename",
      separator = '',
    }
  };
  right = {
      component = 'ShowFileInfo',
      separator = '',
      highlight = {'#008080','#fabd2f'},
  }
}

M.setup(section)

return M
