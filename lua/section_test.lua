-- section setup
-- test data
-- TODO: the order of component
local left,right,short_line_left,short_line_right = {},{},{},{}
local colors = {
  yellow = '#fabd2f',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#afd700',
  orange = '#FF8800',
  purple = '#5d4d7a',
  magenta = '#d16d9e',
  grey = '#c0c0c0',
  blue = '#0087d7',
  red = '#ec5f67'
}

left[1] = {
  FirstElement = {
    provider = function() return '▋' end,
    highlight = {colors.blue,colors.yellow}
  },
}
left[2] = {
  ViMode = {
    provider = function()
      local alias = {n = 'NORMAL',i = 'INSERT',c= 'COMMAND',V= 'VISUAL'}
      return alias[vim.fn.mode()]
    end,
    separator = ' ',
    separator_highlight = {colors.yellow,colors.darkblue},
    highlight = {colors.magenta,colors.yellow,'bold'},
  },
}
left[3] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = function()
      if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true
      end
      return false
    end,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.darkblue},
  },
}
left[4] = {
  FileName = {
    provider = 'FileName',
    condition = function()
      if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true
      end
      return false
    end,
    separator = '',
    separator_highlight = {colors.purple,colors.darkblue},
    highlight = {colors.magenta,colors.darkblue}
  }
}
left[5] = {
  FileSize = {
    provider = 'FileSize',
    condition = function()
      if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true
      end
      return false
    end,
    icon = '   ',
    highlight = {colors.green,colors.purple},
    separator = '',
    separator_highlight = {colors.purple,colors.darkblue},
    dynamicswitch = {
      DiagnosticError = {
        provider = 'DiagnosticError',
        icon = ' ',
        highlight = {colors.red,colors.purple}
      },
      DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = ' ',
        highlight = {colors.blue,colors.purple}
      }
    }
  }
}
left[6] = {
  GitIcon = {
    provider = function() return '  ' end,
    highlight = {colors.orange,colors.darkblue},
  }
}
left[7] = {
  GitBranch = {
    provider = 'GitBranch',
    highlight = {colors.grey,colors.darkblue},
  }
}

local checkwidth = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

left[8] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = ' ',
    highlight = {colors.green,colors.darkblue},
  }
}
left[9] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = ' ',
    highlight = {colors.orange,colors.darkblue},
  }
}
left[10] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = ' ',
    highlight = {colors.red,colors.darkblue},
  }
}
left[11] = {
  LeftEnd = {
    provider = function() return '' end,
    separator = '',
    separator_highlight = {colors.purple,colors.purple},
    highlight = {colors.purple,colors.darkblue}
  }
}
right[1]= {
  FileFormat = {
    provider = 'FileFormat',
    separator = '',
    separator_highlight = {colors.purple,colors.purple},
    highlight = {colors.grey,colors.purple},
  }
}
right[2] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' | ',
    separator_highlight = {colors.darkblue,colors.purple},
    highlight = {colors.grey,colors.purple},
  },
}
right[3] = {
  PerCent = {
    provider = 'LinePercent',
    separator = '',
    separator_highlight = {colors.darkblue,colors.purple},
    highlight = {colors.grey,colors.darkblue},
  }
}
right[4] = {
  ScrollBar = {
    provider = 'ScrollBar',
    highlight = {colors.yellow,colors.purple},
  }
}

short_line_left[1] = {
  FileTypeName = {
    provider = 'FileTypeName',
    highlight = {colors.orange,colors.purple}
  }
}
short_line_right[1] = {
  BufferIcon = {
    provider = 'BufferIcon',
    highlight = {colors.orange,colors.purple}
  }
}

return {
  left,right,short_line_left,short_line_right
}
