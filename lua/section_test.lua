-- section setup
-- test data
local M= {
  left = {
    ViMode = {
      provider = 'ShowVimMode',
      separator = '',
      highlight = {'#008080','#fabd2f'},
      icon = {n = 'Normal'}
    },
    FileName = {
      provider = 'FileName',
      separator = '',
      second = {
        DiagnositcOk = {
          provider = 'DiagnosticOk',
          icon = '',
        }
      }
    },
    FileSize = {
      provider = 'FileSize',
      icon = '',
      separator = '',
      highlight = {},
      emptyshow = false,
      switch = {
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
