local OriginalPath = vim.fn.getenv("PATH")
local pathAppended = false

local mygroup = vim.api.nvim_create_augroup("sharmil", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  group = mygroup,
  callback = function()
    if pathAppended then return end

    local path = vim.fn.getcwd() .. "/.venv"
    if vim.fn.isdirectory(path) == 1 then
      pathAppended = true
      vim.fn.setenv("PATH", path .. "/bin:" .. OriginalPath)

      vim.schedule(function()
        for _, client in pairs(vim.lsp.get_active_clients()) do
          if client.attached_buffers and next(client.attached_buffers) ~= nil then
            local ok, err = pcall(vim.cmd, "LspRestart")
            if not ok then
              vim.notify("LspRestart failed: " .. err, vim.log.levels.WARN)
            end
            return
          end
        end
      end)
    end
  end,
})
