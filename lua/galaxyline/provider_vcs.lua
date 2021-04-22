local luv = vim.loop
local vim = vim
local M = {}
local head_cache = {}

-- Return parent path for specified entry (either file or directory), nil if
-- there is none
local function parent_pathname(path)
  local i = path:find("[\\/:][^\\/:]*$")
  if not i then return end
  return path:sub(1, i-1)
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
    return  vim.fn.isdirectory(path..'/'..specified_dir) == 1
  end

  -- Set default path to current directory
  if path == nil then path = '.' end

  -- If we're already have .git directory here, then return current path
  if has_specified_dir(path, dirname) then
    return path..'/'..dirname
  else
    -- Otherwise go up one level and make a recursive call
    path = up_one_level(path)
    if not path then return nil end
    return get_dir_contains(path, dirname)
  end
end

-- Adapted from from clink-completions' git.lua
function M.get_git_dir(path)

  -- Checks if provided directory contains git directory
  local function has_git_dir(dir)
    local git_dir = dir..'/.git'
    if vim.fn.isdirectory(git_dir) == 1 then return git_dir end
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

  -- Check if git directory is absolute path or a relative
  local function is_path_absolute(dir)
    local patterns = {
      '^/',        -- unix
      '^%a:[/\\]', -- windows
    }
    for _, pattern in ipairs(patterns) do
      if string.find(dir, pattern) then
        return true
      end
    end
    return false
  end

  -- If path nil or '.' get the absolute path to current directory
  if not path or path == '.' then
    path = vim.fn.getcwd()
  end

  local git_dir
  -- Check in each path for a git directory, continues until found or reached
  -- root directory
  while path do
    -- Try to get the git directory checking if it exists or from a git file
    git_dir = has_git_dir(path) or has_git_file(path)
    if git_dir ~= nil then
      break
    end
    -- Move to the parent directory, nil if there is none
    path = parent_pathname(path)
  end

  if not git_dir then return end

  if is_path_absolute(git_dir) then
    return git_dir
  end
  return  path .. '/' .. git_dir
end

local function get_git_detached_head()
  local git_branches_file = io.popen("git branch -a --no-abbrev --contains", "r")
  if not git_branches_file then return end
  local git_branches_data = git_branches_file:read("*l")
  io.close(git_branches_file)
  if not git_branches_data then return end

  local branch_name = git_branches_data:match('.*HEAD detached at ([%w/-]+)')
  if branch_name and string.len(branch_name) > 0 then
    return branch_name
  end
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

  local git_dir = M.get_git_dir(current_dir)
  if not git_dir then return end

  -- The function get_git_dir should return the root git path with '.git'
  -- appended to it. Otherwise if a different gitdir is set this substitution
  -- doesn't change the root.
  local git_root = git_dir:gsub('/.git/?$','')
  local head_stat = luv.fs_stat(git_dir .. "/HEAD")

  if head_stat and head_stat.mtime then
    if (head_cache[git_root]
        and head_cache[git_root].mtime == head_stat.mtime.sec
        and head_cache[git_root].branch) then

      if string.len(head_cache[git_root].branch) ~= 0 then
        return head_cache[git_root].branch
      end
    else
      local head_file = luv.fs_open(git_dir .. "/HEAD", "r", 438)
      if not head_file then return end
      local head_data = luv.fs_read(head_file, head_stat.size, 0)
      if not head_data then return end
      luv.fs_close(head_file)

      head_cache[git_root] = {
        head = head_data,
        mtime = head_stat.mtime.sec
      }
    end
  else
    return
  end

  local branch_name = head_cache[git_root].head:match("ref: refs/heads/([^\n\r%s]+)")
  if not branch_name then
    -- check if detached head
    branch_name = get_git_detached_head()
    if not branch_name then return end
    branch_name = "detached at " .. branch_name
  end

  head_cache[git_root].branch = branch_name
  return branch_name
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
