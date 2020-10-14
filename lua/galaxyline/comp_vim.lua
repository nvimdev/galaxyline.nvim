local M = {}

function M.show_vim_mode()
  return vim.fn.mode()
end

return M
