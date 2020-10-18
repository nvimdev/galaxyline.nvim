-- section setup
-- test data
-- TODO: the order of component
local left,right = {},{}

left[1] = {
  ViMode = {
    provider = 'ShowVimMode',
    separator = '',
    separator_highlight = {'#008080','#fabd2f'},
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
      separator = '',
      highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color(),'NONE'}
  },
};
right[1] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' | ',
    highlight = {'#008080','#fabd2f'},
  },
}
right[2] = {
  PerCent = {
      provider = 'LinePercent',
      highlight = {'#008080','#fabd2f'},
  }
}

return {
  left,right
}
