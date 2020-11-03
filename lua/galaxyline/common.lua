local M = {}

--- Check if a file or directory exists in this path
function M.exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

--- Check if a directory exists in this path
function M.is_dir(path)
  -- "/" works on both Unix and Windows
  return M.exists(path.."/")
end

function M.has_value (tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end

function M.nvim_create_augroups(definition)
  vim.api.nvim_command('augroup galaxyline_user_event')
  vim.api.nvim_command('autocmd!')
  for _, def in ipairs(definition) do
    local command = string.format('autocmd %s * lua require("galaxyline").load_galaxyline()',def)
    vim.api.nvim_command(command)
  end
  vim.api.nvim_command('augroup END')
end

return M
