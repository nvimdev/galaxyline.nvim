# galaxyline.nvim

galaxyline componentizes vim's statusline, the text of each area is provided by a component.

Means you can use the api provided by galaxyline to make the statusline that you want easily.

## Install

```vim
Plug `glepnir/galaxyline-nvim`

If you like icon
Plug `kyazdani42/nvim-web-devicons` or Plug `ryanoasis/vim-devicons`
```

## Api

### Section Variables

Type of these variables both are array table

- `require('galaxyline').short_line_list`  some special filetypes tha show a short statusline like 
  `LuaTree defx coc-explorer vista` etc.

- `require('galaxyline').section.left` is the statusline left section.

- `require('galaxyline').section.right` is the stautsline right section.

- `require('galaxyline').section.short_line_left` statusline left section when filetype in `short_line_list`

- `require('galaxyline').section.short_line_right` statusline right section when filetype in `short_line_list`


### Component keyword

like a FileSize component in left section.

```lua
require('galaxyline').section.left[1]= {
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
  }
}
```
- `provider` can be string or function or table. When it's string,it will match the default provider

  group.If not match,you will got an error. Also you can use mulitple default providers in `provider`

  then you must use an array table for `provider`.

  defualt provider group:

  ```lua
    -- source provider function
    local diagnostic = require('galaxyline.provider_diagnostic')
    local vimmode = require('galaxyline.provider_vim')
    local vcs = require('galaxyline.provider_vcs')
    local fileinfo = require('galaxyline.provider_fileinfo')
    local extension = require('galaxyline.provider_extensions')
    local colors = require('galaxyline.colors')
    local buffer = require('galaxyline.provider_buffer')

    -- provider 
    BufferIcon  = buffer.get_buffer_type_icon,
    BufferNumber = buffer.get_buffer_number,
    FileTypeName = buffer.get_buffer_filetype,
    ShowVimMode = vimmode.show_vim_mode,
    GitBranch = vcs.get_git_branch,
    DiffAdd = vcs.diff_add,             -- support vim-gitgutter vim-signify coc-git
    DiffModified = vcs.diff_modified,   -- support vim-gitgutter vim-signify coc-git
    DiffRemove = vcs.diff_remove,       -- support vim-gitgutter vim-signify coc-git
    LineColumn = fileinfo.line_column,
    FileFormat = fileinfo.get_file_format,
    FileEncode = fileinfo.get_file_encode,
    FileSize = fileinfo.get_file_size,
    FileIcon = fileinfo.get_file_icon,
    FileName = fileinfo.get_current_file_name,
    LinePercent = fileinfo.current_line_percent,
    ScrollBar = extension.scrollbar_instance,
    VistaPlugin = extension.vista_nearest,
    DiagnosticError = diagnostic.get_diagnostic_error, -- support nvim-lsp coc ale
    DiagnosticWarn = diagnostic.get_diagnostic_warn,   -- support nvim-lsp coc ale
  ```
  Also you can use source of provider  function.

- `condition` is a function , It must return a boolean. when it return true that will load this
  component.

- `icon` is a string, It will add to head of the provider result.

- `highlight` the first element is `fg`,second is `bg`,third is `gui`

- `separator` string

- `separator_highlight` same as highlight


you can check the [spaceline.lua](./example/spaceline.lua) file to see how can I use to build
a statuslien.

![spaceline](https://user-images.githubusercontent.com/41671631/97022368-9d12fb80-1586-11eb-868b-f0230c0b02e4.png)
