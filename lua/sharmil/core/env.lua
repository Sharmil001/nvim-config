-- ~/.config/nvim/lua/sharmil/core/env.lua

local M = {}

-- Function to find .python-version file
local function find_python_version_file()
  local cwd = vim.fn.getcwd()
  local path = cwd

  -- Search up the directory tree
  while path ~= "/" do
    local version_file = path .. "/.python-version"
    if vim.fn.filereadable(version_file) == 1 then
      return version_file
    end
    path = vim.fn.fnamemodify(path, ":h")
  end

  return nil
end

-- Function to read environment name from .python-version
local function read_env_name(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return nil
  end

  local content = file:read("*line")
  file:close()

  return content and vim.trim(content) or nil
end

-- Function to set Python provider based on pyenv
local function setup_python_provider()
  local ok, err = pcall(function()
    local version_file = find_python_version_file()

    if version_file then
      local env_name = read_env_name(version_file)

      if env_name then
        -- Construct pyenv path
        local pyenv_root = os.getenv("PYENV_ROOT") or (os.getenv("HOME") .. "/.pyenv")
        local python_path

        -- Check if it's a virtual environment (contains /)
        if string.match(env_name, "/") then
          python_path = pyenv_root .. "/versions/" .. env_name .. "/bin/python"
        else
          python_path = pyenv_root .. "/versions/" .. env_name .. "/bin/python"
        end

        -- Verify the Python executable exists
        if vim.fn.executable(python_path) == 1 then
          vim.g.python3_host_prog = python_path
          -- Silent success, don't print every time
        else
          -- Silently fallback, don't spam warnings
          vim.g.python3_host_prog = vim.fn.exepath("python3") or "python3"
        end
      end
    else
      -- Fallback to pyenv global or system Python
      local pyenv_which = vim.fn.system("pyenv which python 2>/dev/null"):gsub("%s+", "")
      if vim.fn.executable(pyenv_which) == 1 then
        vim.g.python3_host_prog = pyenv_which
      else
        vim.g.python3_host_prog = vim.fn.exepath("python3") or "python3"
      end
    end
  end)

  if not ok then
    -- Silently fallback on any error
    vim.g.python3_host_prog = vim.fn.exepath("python3") or "python3"
  end
end

-- Function to reload environment when changing directories
local function setup_autocommands()
  vim.api.nvim_create_autocmd("DirChanged", {
    pattern = "*",
    callback = function()
      setup_python_provider()
    end,
    desc = "Update Python environment on directory change",
  })
end

-- Initialize
M.setup = function()
  setup_python_provider()
  setup_autocommands()
end

-- Manual reload function
M.reload = function()
  setup_python_provider()
end

-- Run setup immediately
M.setup()

return M
