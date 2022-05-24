local vim = vim
local M = {}

function M.get_search_results()
  local search_term = vim.fn.getreg('/')
  local search_count = vim.fn.searchcount({recompute = 1, maxcount = -1})
  local active = vim.v.hlsearch == 1 and search_count.total > 0

  if active then
    return '/' .. search_term .. '[' .. search_count.current .. '/' .. search_count.total .. ']'
  end
end

return M
