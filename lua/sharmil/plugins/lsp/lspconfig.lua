-- return {
--   "neovim/nvim-lspconfig",
--   event = { "BufReadPre", "BufNewFile" },
--   dependencies = {
--     "hrsh7th/cmp-nvim-lsp",
--     { "antosha417/nvim-lsp-file-operations", config = true },
--     { "folke/neodev.nvim", opts = {} },
--   },
--   config = function()
--     -- import lspconfig plugin
--     local lspconfig = require("lspconfig")
--
--     -- import cmp-nvim-lsp plugin
--     local cmp_nvim_lsp = require("cmp_nvim_lsp")
--
--     local keymap = vim.keymap -- for conciseness
--
--     -- used to enable autocompletion (assign to every lsp server config)
--     local capabilities = cmp_nvim_lsp.default_capabilities()
--
--     local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
--     for type, icon in pairs(signs) do
--       local hl = "DiagnosticSign" .. type
--       vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
--     end
--
--     -- Common on_attach function for all servers
--     local on_attach = function(client, bufnr)
--       local opts = { buffer = bufnr, silent = true }
--
--       -- set keybinds
--       opts.desc = "Show LSP references"
--       keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
--
--       opts.desc = "Go to declaration"
--       keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
--
--       opts.desc = "Show LSP definitions"
--       keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
--
--       opts.desc = "Show LSP implementations"
--       keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
--
--       opts.desc = "Show LSP type definitions"
--       keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
--
--       opts.desc = "See available code actions"
--       keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
--
--       opts.desc = "Smart rename"
--       keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
--
--       opts.desc = "Show buffer diagnostics"
--       keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
--
--       opts.desc = "Show line diagnostics"
--       keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
--
--       opts.desc = "Go to previous diagnostic"
--       keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
--
--       opts.desc = "Go to next diagnostic"
--       keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
--
--       opts.desc = "Show documentation for what is under cursor"
--       keymap.set("n", "K", vim.lsp.buf.hover, opts)
--
--       opts.desc = "Restart LSP"
--       keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
--     end
--
--     -- Configure each LSP server individually
--     -- This replaces the mason_lspconfig.setup_handlers approach
--
--     -- Biome (JavaScript/TypeScript formatter and linter)
--     lspconfig.biome.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--     })
--
--     -- CSS Language Server
--     lspconfig.cssls.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--     })
--
--     -- Emmet for HTML/CSS
--     lspconfig.emmet_ls.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--       filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
--     })
--
--     -- GraphQL Language Server
--     lspconfig.graphql.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--       filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
--     })
--
--     -- HTML Language Server
--     lspconfig.html.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--     })
--
--     -- Lua Language Server
--     lspconfig.lua_ls.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--       settings = {
--         Lua = {
--           runtime = {
--             version = "LuaJIT",
--           },
--           workspace = {
--             library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
--             checkThirdParty = false, -- Disable third-party checking
--           },
--           diagnostics = {
--             globals = { "vim" },
--           },
--           completion = {
--             callSnippet = "Replace",
--           },
--           telemetry = {
--             enable = false,
--           },
--         },
--       },
--     })
--
--     -- Prisma Language Server
--     lspconfig.prismals.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--     })
--
--     -- Python Language Server
--     lspconfig.pyright.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--     })
--
--     -- Svelte Language Server
--     lspconfig.svelte.setup({
--       capabilities = capabilities,
--       on_attach = function(client, bufnr)
--         on_attach(client, bufnr) -- Call the common on_attach function
--
--         -- Svelte-specific configuration
--         vim.api.nvim_create_autocmd("BufWritePost", {
--           pattern = { "*.js", "*.ts" },
--           callback = function(ctx)
--             client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
--           end,
--         })
--       end,
--     })
--
--     -- Tailwind CSS Language Server
--     lspconfig.tailwindcss.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--     })
--
--     -- TypeScript Language Server
--     lspconfig.ts_ls.setup({
--       capabilities = capabilities,
--       on_attach = on_attach,
--     })
--   end,
-- }
-- NEW

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    -- Enhanced LSP capabilities for completion engines
    local capabilities = cmp_nvim_lsp.default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- Configure diagnostics with new API (Neovim 0.11+)
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
      virtual_text = true,
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

    -- Shared on_attach for all servers
    local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, silent = true }

      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      opts.desc = "Go to definition"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
      opts.desc = "View implementations"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
      opts.desc = "Type definitions"
      keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
      opts.desc = "Code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      opts.desc = "Rename symbol"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      opts.desc = "Buffer diagnostics"
      keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
      opts.desc = "Line diagnostics"
      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
      opts.desc = "Previous diagnostic"
      keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      opts.desc = "Next diagnostic"
      keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      opts.desc = "Hover documentation"
      keymap.set("n", "K", vim.lsp.buf.hover, opts)
      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
    end

    -- Define LSP servers and settings
    local servers = {
      html = {},
      cssls = {},
      emmet_ls = {
        filetypes = {
          "html",
          "typescriptreact",
          "javascriptreact",
          "css",
          "sass",
          "scss",
          "less",
          "svelte",
        },
      },
      graphql = {
        filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
      },
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
          },
        },
      },
      prismals = {},
      pyright = {},
      svelte = {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end,
      },
      tailwindcss = {},
      ts_ls = {},
    }

    local lspconfig = require("lspconfig")

    for name, opts in pairs(servers) do
      local config = vim.tbl_extend("force", {
        capabilities = capabilities,
        on_attach = on_attach,
      }, opts)

      lspconfig[name].setup(config)
    end
  end,
}
