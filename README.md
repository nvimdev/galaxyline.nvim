# galaxyline.nvim

galaxyline is a light-weight and super fast statusline plugin. Galaxyline
componentizes Vim's statusline by having a provider for each text area.

This means you can use the api provided by galaxyline to create the statusline
that you want, easily.

**Requires neovim 5.0+**

## Install
* vim-plug
```vim
Plug 'glepnir/galaxyline.nvim'

" If you want to display icons, then use one of these plugins:
Plug 'kyazdani42/nvim-web-devicons' " lua
Plug 'ryanoasis/vim-devicons' " vimscript
```
* packer.nvim
```lua
use {
  'glepnir/galaxyline.nvim',
    branch = 'main',
    -- your statusline
    config = function() require'my_statusline' end,
    -- some optional icons
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
}
```

## Api

### Section Variables

The type of all of these section variables:

- `require('galaxyline').short_line_list` some special filetypes that show a
    short statusline like `LuaTree defx coc-explorer vista` etc.

- `require('galaxyline').section.left` the statusline left section.

- `require('galaxyline').section.right` the stautsline right section.

- `require('galaxyline').section.short_line_left` the statusline left section
    when filetype is in `short_line_list`

- `require('galaxyline').section.short_line_right` statusline right section when
    filetype is in `short_line_list`


### Component keyword

Example of a FileSize component in the left section:

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
`provider` can be a string, function or table. When it's a string, it will match
the default provider group. If it doesn't match an existing group you will get
an error. You can also use multiple default providers in `provider`. If you are
using multiple then you must provide an array table for `provider`.

#### Default provider groups:

```lua
-- source provider function
local diagnostic = require('galaxyline.provider_diagnostic')
local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')
local extension = require('galaxyline.provider_extensions')
local colors = require('galaxyline.colors')
local buffer = require('galaxyline.provider_buffer')

-- provider 
BufferIcon  = buffer.get_buffer_type_icon,
BufferNumber = buffer.get_buffer_number,
FileTypeName = buffer.get_buffer_filetype,
-- Git Provider
GitBranch = vcs.get_git_branch,
DiffAdd = vcs.diff_add,             -- support vim-gitgutter vim-signify gitsigns
DiffModified = vcs.diff_modified,   -- support vim-gitgutter vim-signify gitsigns
DiffRemove = vcs.diff_remove,       -- support vim-gitgutter vim-signify gitsigns
-- File Provider
LineColumn = fileinfo.line_column,
FileFormat = fileinfo.get_file_format,
FileEncode = fileinfo.get_file_encode,
FileSize = fileinfo.get_file_size,
FileIcon = fileinfo.get_file_icon,
FileName = fileinfo.get_current_file_name,
LinePercent = fileinfo.current_line_percent,
ScrollBar = extension.scrollbar_instance,
VistaPlugin = extension.vista_nearest,
-- Diagnostic Provider
DiagnosticError = diagnostic.get_diagnostic_error,
DiagnosticWarn = diagnostic.get_diagnostic_warn,
DiagnosticHint = diagnostic.get_diagnostic_hint,
DiagnosticInfo = diagnostic.get_diagnostic_info,

-- public libs

-- find git root, you can use this to check if the project is a git workspace
require('galaxyline.provider_vcs').check_git_workspace() 
require('galaxyline.provider_fileinfo').get_file_icon_color -- get file icon color
-- custom file icon with color
local my_icons = require('galaxyline.provider_fileinfo').define_file_icon() -- get file icon color
my_icons['your file type here'] = { color code, icon}
-- if your filetype does is not defined in neovim  you can use file extensions
my_icons['your file ext  in here'] = { color code, icon}
```

You can also use the source of the provider function.

- `condition` is a function that must return a boolean. If it returns true then it
    will load the component.

- `icon` is a string that will be added to the head of the provider result.

- `highlight` the first element is `fg`, the second is `bg`, and the third is `gui`.

- `separator` is a string. It is not just a separator. Any statusline item can be
    defined here, like `%<`,`%{}`,`%n`, and so on.

- `separator_highlight` same as highlight

- `event` type is string. You configure a plugin's event that will reload the statusline.


## Awesome Show

- author: glepnir

![](https://user-images.githubusercontent.com/41671631/104537422-e9854900-5654-11eb-8e17-bad8155238b1.png)

- author: ChristianChiarulli

![](https://user-images.githubusercontent.com/29136904/97791654-2b9d0380-1bab-11eb-8133-d8160d3f72cd.png)

- author: BenoitPingris

![](https://user-images.githubusercontent.com/29386109/98808605-b3d99f00-241c-11eb-81dc-0caa852fe478.png)

- author: Th3Whit3Wolf

![](https://user-images.githubusercontent.com/48275422/101280897-c51b8e80-37c3-11eb-8bc3-be52fb4b6465.png)

- author: voitd

![](https://user-images.githubusercontent.com/60138143/103373409-8d131d00-4add-11eb-8dfc-40a37422f430.png)

You can find more custom galaxyline examples [here](https://github.com/glepnir/galaxyline.nvim/issues/12)

# License

MIT
