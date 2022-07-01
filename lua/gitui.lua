local open_floating_window = require"gitui.window".open_floating_window
local project_root_dir  = require"gitui.utils".project_root_dir
local is_gitui_available = require"gitui.utils".is_gitui_available
local is_symlink = require"gitui.utils".is_symlink

local fn = vim.fn

GITUI_BUFFER = nil
GITUI_LOADED = false
vim.g.gitui_opened = 0
local prev_win = -1

--- on_exit callback function to delete the open buffer when gitui exits in a neovim terminal
local function on_exit(job_id, code, event)
  if code ~= 0 then
    return
  end

  vim.cmd('silent! :q')
  GITUI_BUFFER = nil
  GITUI_LOADED = false
  vim.g.gitui_opened = 0
  vim.cmd('silent! :checktime')
  if vim.api.nvim_win_is_valid(prev_win) then
    vim.api.nvim_set_current_win(prev_win)
    prev_win = -1
  end
end

--- Call gitui
local function exec_gitui_command(cmd)
  if GITUI_LOADED == false then
    -- ensure that the buffer is closed on exit
    vim.g.gitui_opened = 1
    vim.fn.termopen(cmd, { on_exit = on_exit })
  end
  vim.cmd 'startinsert'
end


--- :GitUi entry point
local function gitui(path)
  if is_gitui_available() ~= true then
    print('Please install gitui. Check documentation for more information')
    return
  end

  prev_win = vim.api.nvim_get_current_win()

  open_floating_window()

  local cmd = 'gitui'

  -- set path to the root path
  _ = project_root_dir()

  if path == nil then
    if is_symlink() then
      path = project_root_dir()
    end
  else
      if fn.isdirectory(path) then
        cmd = cmd .. ' -p ' .. path
      end
  end

  exec_gitui_command(cmd)
end

--- :GitUiFilter entry point
local function gituifilter(path)
  if is_gitui_available() ~= true then
    print('Please install gitui. Check documentation for more information')
    return
  end
  if path == nil then
    path = project_root_dir()
  end
  prev_win = vim.api.nvim_get_current_win()
  open_floating_window()
  local cmd = 'gitui ' .. '-f ' .. path
  exec_gitui_command(cmd)
end

--- :GitUiFilterCurrentFile entry point
local function gituifiltercurrentfile()
  local current_file = vim.fn.expand('%')
  gituifilter(current_file)
end

--- :GitUiConfig entry point
local function gituiconfig()
  local os = fn.substitute(fn.system('uname'), '\n', '', '')
  local config_file = '~/.config/gitui/key_bindings.ron'
  if fn.empty(fn.glob(config_file)) == 1 then
    -- file does not exist
    -- check if user wants to create it
    local answer = fn.confirm('File ' .. config_file
                                  .. ' does not exist.\nDo you want to create the file and populate it with the default configuration?',
                              '&Yes\n&No')
    if answer == 2 then
      return nil
    end
    if fn.isdirectory(fn.fnamemodify(config_file, ':h')) == false then
      -- directory does not exist
      fn.mkdir(fn.fnamemodify(config_file, ':h'), 'p')
    end
    vim.cmd('edit ' .. config_file)
    vim.cmd([[execute "silent! 0read !gitui -c"]])
    vim.cmd([[execute "normal 1G"]])
  else
    vim.cmd('edit ' .. config_file)
  end
end

return {
  gitui = gitui,
  gituifilter = gituifilter,
  gituifiltercurrentfile = gituifiltercurrentfile,
  gituiconfig = gituiconfig,
  project_root_dir = project_root_dir,
}
