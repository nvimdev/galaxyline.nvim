local vim = vim
local common = require('galaxyline.common')
local M = {}

-- Return parent path for specified entry (either file or directory)
local function parent_pathname(path)
  local prefix = ""
  local i = path:find("[\\/:][^\\/:]*$")
  if i then
    prefix = path:sub(1, i-1)
  end
  return prefix
end

local function get_dir_contains(path, dirname)

  -- Navigates up one level
  local function up_one_level(path)
    if not path == nil or path == '.' then
      path = vim.fn.getcwd()
    end
    return parent_pathname(path)
  end

  -- Checks if provided directory contains git directory
  local function has_specified_dir(path, specified_dir)
    if path == nil then path = '.' end
    return  common.is_dir(path..'/'..specified_dir)
  end

  -- Set default path to current directory
  if path == nil then path = '.' end

  -- If we're already have .git directory here, then return current path
  if has_specified_dir(path, dirname) then
    return path..'/'..dirname
  else
    -- Otherwise go up one level and make a recursive call
    local parent_path = up_one_level(path)
    if parent_path == path then
      return nil
    else
      return get_dir_contains(parent_path, dirname)
    end
  end
end

-- Adapted from from clink-completions' git.lua
function M.get_git_dir(path)

  -- Checks if provided directory contains git directory
  local function has_git_dir(dir)
    local git_dir = dir..'/.git'
    if common.is_dir(git_dir) then return git_dir end
  end

  -- Get git directory from git file if present
  local function has_git_file(dir)
    local gitfile = io.open(dir..'/.git')
    if gitfile ~= nil then
      local git_dir = gitfile:read():match('gitdir: (.*)')
      gitfile:close()

      return git_dir
    end
  end

  -- If path nil or '.' get the absolute path to current directory
  if not path or path == '.' then
    path = vim.fn.getcwd()
  end

  local git_dir
  -- Check in each path for a git directory, continues until found or reached
  -- root directory
  while true do
    -- Try to get the git directory checking if it exists or from a git file
    git_dir = has_git_dir(path) or has_git_file(path)
    if git_dir ~= nil then
      break
    end
    -- Move to the parent directory, nil if there is none
    local parent_path = parent_pathname(path)
    if parent_path == path then
      break
    end
    path = parent_path
  end

  if not git_dir then return end

  -- Check if git directory is absolute path or a relative
  if git_dir:sub(1,1) == '/' then
    return git_dir
  end
  return  path .. '/' .. git_dir
end

function M.check_git_workspace()
  if vim.bo.buftype == 'terminal' then return false end
  local current_file = vim.fn.expand('%:p')
  local current_dir
  -- if file is a symlinks
  if vim.fn.getftype(current_file) == 'link' then
    local real_file = vim.fn.resolve(current_file)
    current_dir = vim.fn.fnamemodify(real_file,':h')
  else
    current_dir = vim.fn.expand('%:p:h')
  end
  local result = M.get_git_dir(current_dir)
  if not result then return false end
  return true
end

function M.get_git_branch()
  if vim.bo.filetype == 'help' then return end
  local current_file = vim.fn.expand('%:p')
  local current_dir

  -- If file is a symlinks
  if vim.fn.getftype(current_file) == 'link' then
    local real_file = vim.fn.resolve(current_file)
    current_dir = vim.fn.fnamemodify(real_file,':h')
  else
    current_dir = vim.fn.expand('%:p:h')
  end

  local _,gitbranch_pwd = pcall(vim.api.nvim_buf_get_var,0,'gitbranch_pwd')
  local _,gitbranch_path = pcall(vim.api.nvim_buf_get_var,0,'gitbranch_path')
  if gitbranch_path and gitbranch_pwd then
    if gitbranch_path:find(current_dir) and string.len(gitbranch_pwd) ~= 0 then
      return  gitbranch_pwd
    end
  end
  local git_dir = M.get_git_dir(current_dir)
  if not git_dir then return end

  -- The function get_git_dir should return the root git path with '.git'
  -- appended to it. Otherwise if a different gitdir is set this substitution
  -- doesn't change the root.
  local git_root = git_dir:gsub('/.git/?$','')

  -- If git directory not found then we're probably outside of repo or
  -- something went wrong. The same is when head_file is nil
  local head_file = io.open(git_dir..'/HEAD')
  if not head_file then return end

  local HEAD = head_file:read()
  head_file:close()

  -- If HEAD matches branch expression, then we're on named branch
  -- otherwise it is a detached commit
  local branch_name = HEAD:match('ref: refs/heads/(.+)')
  if branch_name == nil then return  end

  vim.api.nvim_buf_set_var(0,'gitbranch_pwd',branch_name)
  vim.api.nvim_buf_set_var(0,'gitbranch_path',git_root)

  return branch_name .. ' '
end

-- Get diff data
-- support plugins: vim-gitgutter vim-signify coc-git
local function get_hunks_data()
  -- diff data 1:add 2:modified 3:remove
  local diff_data = {0,0,0}
  if vim.fn.exists('*GitGutterGetHunkSummary') == 1 then
    for idx,v in pairs(vim.fn.GitGutterGetHunkSummary()) do
      diff_data[idx] = v
    end
    return diff_data
  elseif vim.fn.exists('*sy#repo#get_stats') == 1 then
    diff_data[1] = vim.fn['sy#repo#get_stats']()[1]
    diff_data[2] = vim.fn['sy#repo#get_stats']()[2]
    diff_data[3] = vim.fn['sy#repo#get_stats']()[3]
    return diff_data
  elseif vim.fn.exists('b:gitsigns_status') == 1 then
    local gitsigns_dict = vim.api.nvim_buf_get_var(0, 'gitsigns_status')
    diff_data[1] = tonumber(gitsigns_dict:match('+(%d+)')) or 0
    diff_data[2] = tonumber(gitsigns_dict:match('~(%d+)')) or 0
    diff_data[3] = tonumber(gitsigns_dict:match('-(%d+)')) or 0
  end
  return diff_data
end

function M.diff_add()
  local add = get_hunks_data()[1]
  if add > 0 then
    return add .. ' '
  end
end

function M.diff_modified()
  local modified = get_hunks_data()[2]
  if modified > 0 then
    return modified .. ' '
  end
end

function M.diff_remove()
  local removed = get_hunks_data()[3]
  if removed > 0 then
    return removed .. ' '
  end
end

return M
