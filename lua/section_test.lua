-- section setup
-- test data
-- TODO: the order of component
local left,right = {},{}

left[1] = {
  ViMode = {
    provider = 'ShowVimMode',
    separator = '',
    separator_highlight = {'#fabd2f','#5d4d7a'},
    highlight = {'#008080','#fabd2f'},
    aliasby = {n = 'Normal',i = 'Insert',c = 'Command'}
  },
}
left[2] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = function()
      if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true
      end
      return false
    end,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color(),'#5d4d7a'},
  },
}
left[3] = {
  FileName = {
    provider = 'FileName',
    condition = function()
      if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true
      end
      return false
    end,
    separator = ' ',
    separator_highlight = {'#fabd2f','#5d4d7a'},
    highlight = {'#FF8800','#5d4d7a'}
  }
}
left[4] = {
  DiagnosticOk = {
    provider = 'DiagnosticOk',
    condition = function()
      if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true
      end
      return false
    end,
    icon = ' ',
    highlight = {'#afd700','#fabd2f'}
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
    highlight = {'#afd700','#fabd2f'}
  }
}
right[1]= {
  FileFormat = {
    provider = 'FileFormat',
    separator = '',
    highlight = {'#008080','#fabd2f'},
  }
}
right[2] = {
  FileEncode = {
    provider = 'FileEncode',
    separator = '',
    highlight = {'#008080','#fabd2f'},
  }
}
right[3] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = '',
    highlight = {'#008080','#fabd2f'},
  },
}
right[4] = {
  PerCent = {
      provider = 'LinePercent',
      highlight = {'#008080','#fabd2f'},
  }
}
right[5] = {
  ScrollBar = {
    provider = 'ScrollBar',
    highlight = {'#008080','#fabd2f'},
  }
}

return {
  left,right
}
