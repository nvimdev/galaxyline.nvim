local vim,api = vim,vim.api
local common = require('galaxyline.common')
local M = {}

local function get_dir_contains(path, dirname)

    -- return parent path for specified entry (either file or directory)
    local function pathname(path)
        local prefix = ""
        local i = path:find("[\\/:][^\\/:]*$")
        if i then
            prefix = path:sub(1, i-1)
        end
        return prefix
    end

    -- Navigates up one level
    local function up_one_level(path)
        if path == nil then path = '.' end
        if path == '.' then path = io.popen"cd":read'*l' end
        return pathname(path)
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

-- adapted from from clink-completions' git.lua
function M.get_git_dir(path)

    -- return parent path for specified entry (either file or directory)
    local function pathname(path)
        local prefix = ""
        local i = path:find("[\\/:][^\\/:]*$")
        if i then
            prefix = path:sub(1, i-1)
        end

        return prefix
    end

    -- Checks if provided directory contains git directory
    local function has_git_dir(dir)
        if  common.is_dir(dir..'/.git') then return dir end
    end

    local function has_git_file(dir)
        local gitfile = io.open(dir..'/.git')
        if not gitfile then return false end

        local git_dir = gitfile:read():match('gitdir: (.*)')
        gitfile:close()

        return git_dir and dir..'/'..git_dir
    end

    -- Set default path to current directory
    if not path or path == '.' then path = io.popen"cd":read'*l' end

    -- Calculate parent path now otherwise we won't be
    -- able to do that inside of logical operator
    local parent_path = pathname(path)

    return has_git_dir(path)
        or has_git_file(path)
        -- Otherwise go up one level and make a recursive call
        or (parent_path ~= path and M.get_git_dir(parent_path) or nil)
end

function M.get_git_branch()
  if vim.bo.filetype == 'help' then return end
  local current_dir = vim.fn.expand('%:p:h')
  local ok,gitbranch_pwd = pcall(vim.api.nvim_buf_get_var,0,'gitbranch_pwd')
  local ok1,gitbranch_path = pcall(vim.api.nvim_buf_get_var,0,'gitbranch_path')
  if ok and ok1 then
    if gitbranch_path:find(current_dir) and string.len(gitbranch_pwd) ~= 0 then
      return  gitbranch_pwd
    end
  end
  local git_root = M.get_git_dir(current_dir)
  if not git_root then return end
  local git_dir = git_root .. '/.git'

  -- If git directory not found then we're probably outside of repo
  -- or something went wrong. The same is when head_file is nil
  local head_file = git_dir and io.open(git_dir..'/HEAD')
  if not head_file then return end

  local HEAD = head_file:read()
  head_file:close()

  -- if HEAD matches branch expression, then we're on named branch
  -- otherwise it is a detached commit
  local branch_name = HEAD:match('ref: refs/heads/(.+)')

  vim.api.nvim_buf_set_var(0,'gitbranch_pwd',branch_name)
  vim.api.nvim_buf_set_var(0,'gitbranch_path',git_root)

  return branch_name .. ' '
end

-- get diff datas
-- support plugins: vim-gitgutter vim-signify coc-git
local function get_hunks_data()
  -- diff data 1:add 2:modified 3:remove
  local diff_data = {0,0,0}
  if vim.fn.exists('*GitGutterGetHunkSummary') == 1 then
    diff_data[1] = vim.fn.GitGutterGetHunkSummary()
    diff_data[2] = vim.fn.GitGutterGetHunkSummary()
    diff_data[3] = vim.fn.GitGutterGetHunkSummary()
    return diff_data
  elseif vim.fn.exists('*sy#repo#get_stats') == 1 then
    diff_data[1] = vim.fn['sy#repo#get_stats']()[1]
    diff_data[2] = vim.fn['sy#repo#get_stats']()[2]
    diff_data[3] = vim.fn['sy#repo#get_stats']()[3]
    return diff_data
  elseif vim.fn.exists('*coc#rpc#start_server') == 1 then
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
    return diff_data
  elseif vim.fn.exists('b:gitsigns_status_dict') == 1 then
    local gitsigns_dict = vim.api.nvim_buf_get_var(0, 'gitsigns_status_dict')
    diff_data[1] = gitsigns_dict['added']
    diff_data[2] = gitsigns_dict['changed']
    diff_data[3] = gitsigns_dict['removed']
  end
  return diff_data
end

function M.diff_add()
  if get_hunks_data()[1] <= 0 then return '' end
  return get_hunks_data()[1] .. ' '
end

function M.diff_modified()
  if get_hunks_data()[2] <= 0 then return '' end
  return get_hunks_data()[2] .. ' '
end

function M.diff_remove()
  if get_hunks_data()[3] <= 0 then return '' end
  return get_hunks_data()[3]
end

return M
