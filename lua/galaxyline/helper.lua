local M = {}

function M.get_plugin_variable(var, default)
  var = "spaceline"..var
  local user_var = vim.g[var]
  return user_var or default
end

return M
