local event = {}

local function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup '..group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

function event.galaxyline_augroups()
  local definition = {
    galaxyline = {
        {'BufNewFile,BufReadPost','*','lua require("galaxyline.com_vcs").gitbranch_detect(expand('<amatch>:p:h')'}
    }
  }
  nvim_create_augroups(definition)
end

return event

