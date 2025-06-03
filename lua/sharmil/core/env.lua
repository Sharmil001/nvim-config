local OriginalPath = vim.fn.getenv("PATH")
local pathAppended = false
local mygroup = vim.api.nvim_create_augroup("sharmil", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*" },
  group = mygroup,
  callback = function()
    if pathAppended then
      return
    end
    local path = vim.fn.getcwd() .. "/.venv"
    if vim.fn.isdirectory(path) == 1 then
      pathAppended = true
      vim.fn.setenv("PATH", path .. "/bin:" .. OriginalPath)
      vim.cmd([[LspRestart]])
    end
  end,
})
