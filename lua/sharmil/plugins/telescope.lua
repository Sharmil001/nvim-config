-- return {
--   "nvim-telescope/telescope.nvim",
--   branch = "0.1.x",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
--     "nvim-tree/nvim-web-devicons",
--     "folke/todo-comments.nvim",
--   },
--   config = function()
--     local telescope = require("telescope")
--     local actions = require("telescope.actions")
--
--     telescope.setup({
--       defaults = {
--         path_display = { "smart" },
--         mappings = {
--           i = {
--             ["<C-k>"] = actions.move_selection_previous, -- move to prev result
--             ["<C-j>"] = actions.move_selection_next, -- move to next result
--             ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
--           },
--         },
--       },
--     })
--
--     telescope.load_extension("fzf")
--
--     -- set keymaps
--     local keymap = vim.keymap -- for conciseness
--
--     keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
--     keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
--     keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
--     keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
--     keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
--   end,
-- }

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    ------------------------------------------------------------------
    -- 🧠 Pyenv Selector
    ------------------------------------------------------------------
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    local function select_pyenv()
      local handle = io.popen("pyenv versions --bare")
      if not handle then
        print("❌ Failed to fetch pyenv versions")
        return
      end
      local result = handle:read("*a")
      handle:close()

      local envs = {}
      for env in result:gmatch("[^\n]+") do
        table.insert(envs, env)
      end

      pickers
        .new({}, {
          prompt_title = "Select Pyenv Environment",
          finder = finders.new_table({ results = envs }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              local env_name = selection[1]
              local python_path = string.format("%s/.pyenv/versions/%s/bin/python", os.getenv("HOME"), env_name)

              vim.g.python_ve = python_path
              vim.g.python3_host_prog = python_path

              -- Optionally write to .python-version in the project directory
              local project_path = vim.fn.getcwd() .. "/.python-version"
              local f = io.open(project_path, "w")
              if f then
                f:write(env_name)
                f:close()
              end

              print("✅ Set Python env: " .. env_name)
              print("📦 Saved to .python-version")
            end)
            return true
          end,
        })
        :find()
    end

    -- 🔑 Keymaps
    local keymap = vim.keymap
    keymap.set("n", "<leader>fe", select_pyenv, { desc = "Select Pyenv Environment" })

    ------------------------------------------------------------------
    -- Your existing Telescope mappings
    ------------------------------------------------------------------
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
  end,
}
