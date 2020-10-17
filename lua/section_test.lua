-- section setup
-- test data
local M= {
  left = {
    -- ViMode = {
    --   provider = 'ShowVimMode',
    --   separator = '',
    --   highlight = {'#008080','#fabd2f'},
    --   aliasby = {n = 'Normal'}
    -- },
    FileIcon = {
      provider = 'FileIcon',
      condition = vim.fn.expand('%:t'),
      separator = '',
      highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color(),''}
    },
  };
}

local test= {
  left = {
    ViMode = {
      provider = 'ShowVimMode',
      separator = '',
      highlight = {'#008080','#fabd2f'},
      aliasby = {n = 'Normal'}
    },
    FileIcon = {
      provider = 'FileIcon',
      separator = '',
      highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color(),''}
    },
    FileName = {
      provider = {'DiagnosticOk','FileName'},
      separator = '',
    },
    FileSize = {
      provider = 'FileSize',
      icon = '',
      iconhighlight = {},
      separator = '',
      highlight = {},
      emptyshow = false,
      dynamicswitch = {
        DiagnositcError = {
          provider = 'DiagnositcError',
          icon = '',
          highlight = {},
        },
        DiagnosticWarn = {
          provider = 'DiagnosticWarn',
          icon = '',
          highlight = {}
        }
      }
    },
    GitBranch = {
      provider = 'GitBranch',
      icon = '',
      separator = '',
      highlight = {},
    },
    Diff = {
      provider = 'DiffAdd',
      emptyshow = false,
      separator = '',
      highlight = {},
      icon = '',
    }
  };
  right = {
    FileInfo = {},
    LineInfo = {
      provider = 'LineColumn',
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

return M
