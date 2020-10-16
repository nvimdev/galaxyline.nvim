local vim = vim
local autocmd = require('galaxyline.event')
local diagnostic = require('galaxyline.component_diagnostic')
local vimmode = require('galaxyline.component_vim')
local vcs = require('galaxyline.component_vcs')
local fileinfo = require('galaxyline.component_fileinfo')
local M = {}

-- section setup
-- test data
M.section = {
  left = {
    ViMode = {
      command = 'ShowVimMode',
      separator = '',
      highlight = {'#008080','#fabd2f'},
      icon = {n = 'Normal'}
    },
    FileName = {
      command = 'FileName',
      separator = '',
      second = {
        DiagnositcOk = {
          command = 'DiagnosticOk',
          icon = '',
        }
      }
    },
    FileSize = {
      command = 'FileSize',
      icon = '',
      separator = '',
      highlight = {},
      emptyshow = false,
      switch = {
        DiagnositcError = {
          command = 'DiagnositcError',
          icon = '',
          highlight = {},
        },
        DiagnosticWarn = {
          command = 'DiagnosticWarn',
          icon = '',
          highlight = {}
        }
      }
    },
    GitBranch = {
      command = 'GitBranch',
      icon = '',
      separator = '',
      highlight = {},
    },
    Diff = {
      command = 'DiffAdd',
      emptyshow = false,
      separator = '',
      highlight = {},
      icon = '',
    }
  };
  right = {
    FileInfo = {},
    LineInfo = {
      command = 'LineColumn',
      separator = '',
      highlight = {'#008080','#fabd2f'},
      second = {
        CurrentPercent = {
          provider = 'LinePercent',
          icon = '',
        }
      }
    };
    ScrollBar = {},
  }
}

local default_provider = {
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

local function exec_command(icon,cmd)
  if type(icon) == 'string' then
    return icon .. cmd()
  elseif type(icon) == 'table' then
    local output = cmd()
    return icon[output]
  end
end

-- component decorator
-- that will output the component result with icon
-- component command and icon can be string or table
function M.component_decorator(component_name)
  -- if section doesn't have component just return
  local ok,position = check_component_exists(component_name)
  if not ok then return end
  local cmd = M.section[position][component_name].command or ''
  local icon = M.section[position][component_name].icon or ''
  if type(cmd) == 'string' then
    if default_provider[cmd] == nil then
      print(string.format('Does not found the command in default command provider in %s'),component_name)
    end
    return exec_command(icon,default_provider[cmd])
  elseif type(cmd) == 'function' then
    return exec_command(icon,cmd)
  elseif type(cmd) == 'table' then
    local output = ''
    for _,v in pairs(table) do
      if type(v) == 'string' then
        if default_provider[v] == nil then
          print(string.format('Does not found the command in default command provider in %s'),component_name)
          return
        end
        output = output + exec_command(icon,default_provider[cmd])
      elseif type(v) == 'function' then
        output = output + exec_command(icon,cmd)
      else
        print(string.format('Wrong command type in %s'),component_name)
      end
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
