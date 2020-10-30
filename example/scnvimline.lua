local gl = require('galaxyline')
local gls = gl.section
gl.short_line_list = {'help', 'help.supercollider', 'scnvim'}

local colors = {
	bg = '#1e1c1e',
	line_bg = '#ce4d02',
	line_bg_dark = '#77000f',

	fg = '#494535',
	invader = '#008780',
	black = '#000000',
	white = '#FFFFFF',
	yellow = '#fabd2f',
	cyan = '#008080',
	darkblue = '#081633',
	darkgreen = '#38773a',
	green = '#afd700',
	orange = '#FF8800',
	purple = '#5d4d7a',
	magenta = '#c678dd',
	darkmagenta = '#733877',
	blue = '#51afef',
	red = '#ec5f67'
}

local buffer_not_empty = function()
	if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
		return true
	end
	return false
end

gls.left[1] = {
	FirstElement = {
		provider = function() return '▊ ' end,
		highlight = {colors.black,colors.line_bg}
	},
}
gls.left[2] = {
	ViMode = {
		provider = function()
			local alias = {
				n = 'N ',
				i = 'I ',
				R = 'R ',
				c= 'C ',
				v= 'V ',
				V= 'VL',
				[''] = 'VB',
				s = 'S ',
				S = 'SL',
				[''] = 'SB',
				t = 'T '
			}
			-- auto change color according the vim mode
			local mode_color = {
				n = colors.black,
				i = colors.yellow,
				v=colors.blue,
				[''] = colors.darkmagenta,
				V=colors.darkgreen,
				c = colors.green,
				no = colors.magenta,
				s = colors.gre,
				S=colors.orange,
				[''] = colors.orange,
				ic = colors.yellow,
				R = colors.purple,
				Rv = colors.purple,
				cv = colors.red,ce=colors.red,
				r = colors.cyan,
				rm = colors.cyan,
				['r?'] = colors.cyan,
				['!']  = colors.red,
				t = colors.red
			}
			vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
			return alias[vim.fn.mode()] .. ' 👾🐙 ' 
		end,
		separator = '| ',
		separator_highlight = {colors.bg,colors.line_bg},
		highlight = {colors.red,colors.line_bg, 'bold'},
	},
}
gls.left[3] ={
	FileIcon = {
		provider = 'FileIcon',
		condition = buffer_not_empty,
		separator = '| ',
		separator_highlight = {colors.bg,colors.line_bg},
		-- highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.black},
		highlight = {colors.black, colors.line_bg},
	},
}
gls.left[4] = {
	FileName = {
		provider = {'FileName','FileSize'},
		condition = buffer_not_empty,
		separator = '|',
		separator_highlight = {colors.bg,colors.line_bg},
		highlight = {colors.invader,colors.line_bg, 'bold'}
	}
}

local function find_git_root()
	local path = vim.fn.expand('%:p:h')
	local get_git_dir = require('galaxyline.provider_vcs').get_git_dir
	return get_git_dir(path)
end

gls.left[5] = {
	GitIcon = {
		provider = function() return ' ⍢⃝  ' end,
		condition = find_git_root,
		highlight = {colors.black,colors.line_bg, 'underline'},
	}
}
gls.left[6] = {
	GitBranch = {
		provider = 'GitBranch',
		condition = find_git_root,
		separator = '|',
		separator_highlight = {colors.bg,colors.line_bg},
		highlight = {colors.green,colors.line_bg, 'underline'},
	}
}

local checkwidth = function()
	local squeeze_width  = vim.fn.winwidth(0) / 2
	if squeeze_width > 40 then
		return true
	end
	return false
end

--gls.left[7] = {
--  DiffAdd = {
--    provider = 'DiffAdd',
--    condition = checkwidth,
--    icon = ' ',
--    highlight = {colors.green,colors.line_bg},
--  }
--}
--gls.left[8] = {
--  DiffModified = {
--    provider = 'DiffModified',
--    condition = checkwidth,
--    icon = ' ',
--    highlight = {colors.orange,colors.line_bg},
--  }
--}
--gls.left[9] = {
--  DiffRemove = {
--    provider = 'DiffRemove',
--    condition = checkwidth,
--    icon = ' ',
--    highlight = {colors.red,colors.line_bg},
--  }
--}
gls.left[10] = {
	LeftEnd = {
		provider = function() return '' end,
		separator = ' | | ||',
		separator_highlight = {colors.bg,colors.line_bg},
		highlight = {colors.black,colors.line_bg}
	}
}
gls.left[11] = {
	DiagnosticError = {
		provider = 'DiagnosticError',
		icon = '  ',
		highlight = {colors.red,colors.bg}
	}
}
gls.left[12] = {
	Space = {
		provider = function () return ' ' end
	}
}
gls.left[13] = {
	DiagnosticWarn = {
		provider = 'DiagnosticWarn',
		icon = '  ',
		highlight = {colors.blue,colors.bg},
	}
}
gls.right[1] = {
	ScnvimStatusLine = {
		provider = function()
			local ssss = vim.api.nvim_call_function("scnvim#statusline#server_status", {})
			return ssss
		end,
		condition = function()
			if vim.api.nvim_get_option("filetype") == "supercollider" then
				return true
			else
				return false
			end
		end,
		icon = ' ↈ  ',
		highlight = {colors.line_bg, colors.bg, 'underline'},
	}
}
gls.right[2]= {
	FileFormat = {
		provider = 'FileFormat',
		separator = ' ▨ ■ ',
		separator_highlight = {colors.bg,colors.line_bg},
		highlight = {colors.fg,colors.line_bg},
	}
}
gls.right[3] = {
	LineInfo = {
		provider = 'LineColumn',
		separator = ' | ',
		separator_highlight = {colors.blue,colors.line_bg},
		highlight = {colors.fg,colors.line_bg},
	},
}
gls.right[4] = {
	PerCent = {
		provider = 'LinePercent',
		separator = ' ',
		separator_highlight = {colors.line_bg,colors.line_bg},
		highlight = {colors.line_bg,colors.darkblue},
	}
}
gls.right[5] = {
	ScrollBar = {
		provider = 'ScrollBar',
		highlight = {colors.line_bg,colors.fg},
	}
}

-- X
-- X
-- shortline
-- X
-- X
gls.short_line_left[1] = {
	BufferType = {
		provider = 'FileTypeName',
		separator = '||',
		separator_highlight = {colors.line_bg,colors.bg},
		highlight = {colors.black,colors.line_bg}
	}
}

gls.short_line_right[1] = {
	BufferIcon = {
		provider= 'BufferIcon',
		separator = ' ▒',
		separator_highlight = {colors.line_bg,colors.bg},
		highlight = {colors.line_bg,colors.white}
	}
}
gls.short_line_right[2] = {
	Dato = {
		provider = function()
			local command = "date +%H:%M-%d.%m.%Y"
			local handle = io.popen(command)
			local result = handle:read("*a")
			handle:close()
			return result
		end,
		condition = function()
			if vim.bo.filetype == "help.supercollider" then
				return true
			else
				return false
			end
		end,
		icon = '⏰',
		highlight = {colors.line_bg,colors.bg},
	}
}
gls.short_line_right[3] = {
	Addr = {
		provider = function()
			local command = "ip addr | grep inet | grep 24 | awk '{print $2}' | sed 's/...$//'"
			local handle = io.popen(command)
			local result = handle:read("*a")
			handle:close()
			return result
		end,
		condition = function()
			if vim.bo.filetype == "scnvim" then
				return true
			else
				return false
			end
		end,
		icon = 'addr: ',
		highlight = {colors.line_bg, colors.bg, 'bold'},
	}
}
