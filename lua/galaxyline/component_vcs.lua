local vim,api = vim,vim.api
local M = {}

-- TODO: find a better way to get git branch
local function gitbranch_dir(path)
  local current_dir = vim.fn.expand('%:p:h')
end

function M.git_branch()
end

-- get diff datas
-- support plugins: vim-gitgutter vim-signify coc-git
local function get_hunks_data()
  -- diff data 1:add 2:modified 3:remove
  local diff_data = {0,0,0}
  if vim.fn.exists('*GitGutterGetHunkSummary') == 1 then
    diff_data[1],diff_data[2],diff_data[3] = vim.fn.GitGutterGetHunkSummary()
  elseif vim.fn.exists('*sy#repo#get_stats') == 1 then
    diff_data[1],diff_data[2],diff_data[3] = vim.fn['sy#repo#get_stats']()
  elseif api.nvim_buf_get_var(0,'coc_git_status') then
    local tmp_data = vim.fn.split(api.nvim_buf_get_var(0,'coc_git_status'),' ')
    local flags = {'+','~','-'}
    if #tmp_data ~= 0 then
      for _,v in pairs(tmp_data) do
        for k,flag in pairs(flags) do
          local pos = v:find(flag)
          if pos ~= nil then
            diff_data[k] = v:sub(pos+1,-1)
          end
        end
      end
    end
  end
  return diff_data
end

function M.diff_add()
  return get_hunks_data[1]
end

function M.diff_modified()
  return get_hunks_data[2]
end

function M.diff_remove()
  return get_hunks_data[3]
end

return M
