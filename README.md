<h1 align="center">
  <img
    src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png"
    height="30"
    width="0px"
  />
  🌌 galaxyline.nvim
  <img
    src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png"
    height="30"
    width="0px"
  />
</h1>

<p align="center">
  <a href="https://github.com/glepnir/galaxyline.nvim/stargazers">
    <img
      alt="Stargazers"
      src="https://img.shields.io/github/stars/glepnir/galaxyline.nvim?style=for-the-badge&logo=starship&color=c678dd&logoColor=d9e0ee&labelColor=282a36"
    />
  </a>
  <a href="https://github.com/glepnir/galaxyline.nvim/issues">
    <img
      alt="Issues"
      src="https://img.shields.io/github/issues/glepnir/galaxyline.nvim?style=for-the-badge&logo=gitbook&color=f0c062&logoColor=d9e0ee&labelColor=282a36"
    />
  </a>
  <a href="https://github.com/glepnir/galaxyline.nvim/contributors">
    <img
      alt="Contributors"
      src="https://img.shields.io/github/contributors/glepnir/galaxyline.nvim?style=for-the-badge&logo=opensourceinitiative&color=abcf84&logoColor=d9e0ee&labelColor=282a36"
    />
  </a>
</p>

&nbsp;

## 💭 About

Galaxyline is a light-weight and **Super Fast** statusline plugin. Galaxyline
componentizes Vim's statusline by having a provider for each text area.

This means you can use the api provided by galaxyline to create the statusline
that you want, easily.

## 🧩 Requires

- [neovim 0.5.0+](https://github.com/neovim/neovim/releases/tag/v0.5.0)

## ⚙️ Setup

- [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'glepnir/galaxyline.nvim' , { 'branch': 'main' }

" If you want to display icons, then use one of these plugins:
Plug 'kyazdani42/nvim-web-devicons' " lua
Plug 'ryanoasis/vim-devicons'       " vimscript
```

- [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
  'glepnir/galaxyline.nvim',
  branch = 'main',
  -- your statusline
  config = function()
    require('my_statusline')
  end,
  -- some optional icons
  requires = { 'kyazdani42/nvim-web-devicons', opt = true },
})
```

## 🧭 Api

### Section Variables

The type of all of these section variables:

- `require('galaxyline').short_line_list` some special filetypes that show a
  short statusline like `LuaTree defx coc-explorer vista` etc.

- `require('galaxyline').section.left` the statusline left section.

- `require('galaxyline').section.mid` the statusline mid section.

- `require('galaxyline').section.right` the statusline right section.

- `require('galaxyline').section.short_line_left` the statusline left section
  when filetype is in `short_line_list` and for inactive window.

- `require('galaxyline').section.short_line_right` statusline right section when
  filetype is in `short_line_list` and for inactive window.

### Component Keyword

Example of a FileSize component in the left section:

```lua
require('galaxyline').section.left[1] = {
  FileSize = {
    provider = 'FileSize',
    condition = function()
      if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true
      end
      return false
    end,
    icon = '   ',
    highlight = { colors.green, colors.purple },
    separator = '',
    separator_highlight = { colors.purple, colors.darkblue },
  },
}
```

`provider` can be a string, function or table. When it's a string, it will match
the default provider group. If it doesn't match an existing group you will get
an error. You can also use multiple default providers in `provider`. If you are
using multiple then you must provide an array table for `provider`.

#### Default Provider Groups:

```lua
-- source provider function
local diagnostic = require('galaxyline.provider_diagnostic')
local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')
local extension = require('galaxyline.provider_extensions')
local colors = require('galaxyline.colors')
local buffer = require('galaxyline.provider_buffer')
local whitespace = require('galaxyline.provider_whitespace')
local lspclient = require('galaxyline.provider_lsp')

-- provider
BufferIcon  = buffer.get_buffer_type_icon,
BufferNumber = buffer.get_buffer_number,
FileTypeName = buffer.get_buffer_filetype,
-- Git Provider
GitBranch = vcs.get_git_branch,
DiffAdd = vcs.diff_add,            -- support vim-gitgutter vim-signify gitsigns
DiffModified = vcs.diff_modified,  -- support vim-gitgutter vim-signify gitsigns
DiffRemove = vcs.diff_remove,      -- support vim-gitgutter vim-signify gitsigns
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
-- Whitespace
Whitespace = whitespace.get_item,
-- Diagnostic Provider
DiagnosticError = diagnostic.get_diagnostic_error,
DiagnosticWarn = diagnostic.get_diagnostic_warn,
DiagnosticHint = diagnostic.get_diagnostic_hint,
DiagnosticInfo = diagnostic.get_diagnostic_info,
-- LSP
GetLspClient = lspclient.get_lsp_client,

-- public libs

require('galaxyline.provider_fileinfo').get_file_icon_color -- get file icon color
-- custom file icon with color
local my_icons = require('galaxyline.provider_fileinfo').define_file_icon() -- get file icon color
my_icons['your file type here'] = { color code, icon}
-- if your filetype does is not defined in neovim  you can use file extensions
my_icons['your file ext  in here'] = { color code, icon}

-- built-in condition
local condition = require('galaxyline.condition')
condition.buffer_not_empty  -- if buffer not empty return true else false
condition.hide_in_width  -- if winwidth(0)/ 2 > 40 true else false
-- find git root, you can use this to check if the project is a git workspace
condition.check_git_workspace()

-- built-in theme
local colors = require('galaxyline.theme').default

bg = '#202328',
fg = '#bbc2cf',
yellow = '#ecbe7b',
cyan = '#008080',
darkblue = '#081633',
green = '#98be65',
orange = '#ff8800',
violet = '#a9a1e1',
magenta = '#c678dd',
blue = '#51afef';
red = '#ec5f67';
```

You can also use the source of the provider function.

- `condition` is a function that must return a boolean. If it returns true then
  it will load the component.

- `icon` is a string that will be added to the head of the provider result.
  It can also be a function that returns a string.

- `highlight` is a string, function or table that can be used in two ways. The
  first is to pass three elements: the first element is `fg`, the second is
  `bg`, and the third is `gui`. The second method is to pass a highlight group
  as a string (such as `IncSearch`) that galaxyline will link to.

- `separator` is a string, function or table. notice that table type only work
  in mid section, It is not just a separator. Any statusline item can be defined
  here, like `%<`,`%{}`,`%n`, and so on.

- `separator_highlight` same as highlight.

- `event` type is string. You configure a plugin's event that will reload the
  statusline.

## 🎉 Awesome Show

- Author: [glepnir](https://github.com/glepnir)

![eviline](https://user-images.githubusercontent.com/41671631/110282770-05d0b100-801a-11eb-91b1-e30eacec9a1c.png)

- Author: [Christian Chiarulli](https://github.com/ChristianChiarulli)

![galaxyline](https://user-images.githubusercontent.com/29136904/97791654-2b9d0380-1bab-11eb-8133-d8160d3f72cd.png)

- Author: [BenoitPingris](https://github.com/bpingris)

![galaxyline](https://user-images.githubusercontent.com/29386109/98808605-b3d99f00-241c-11eb-81dc-0caa852fe478.png)

- Author: [Th3Whit3Wolf](https://github.com/Th3Whit3Wolf)

![galaxyline](https://user-images.githubusercontent.com/48275422/101280897-c51b8e80-37c3-11eb-8bc3-be52fb4b6465.png)

- Author: [voitd](https://github.com/voitd)

![galaxyline](https://user-images.githubusercontent.com/60138143/103373409-8d131d00-4add-11eb-8dfc-40a37422f430.png)

You can find more custom galaxyline examples [here](https://github.com/glepnir/galaxyline.nvim/issues/12).

&nbsp;

<p align="center">
  <img
    src="https://raw.githubusercontent.com/catppuccin/catppuccin/dev/assets/footers/gray0_ctp_on_line.svg?sanitize=true"
  />
</p>
<p align="center">
  Copyright &copy; 2020-present
  <a href="https://github.com/glepnir" target="_blank">Raphael</a>
</p>
<p align="center">
  <a href="https://github.com/glepnir/galaxyline.nvim/blob/main/LICENSE"
    ><img
      src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&logoColor=d9e0ee&colorA=282a36&colorB=c678dd"
  /></a>
</p>
