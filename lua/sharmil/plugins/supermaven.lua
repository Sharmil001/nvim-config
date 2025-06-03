return {
  "supermaven-inc/supermaven-nvim",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  opts = {
    disable_keymaps = false,
    disable_inline_completion = false,
    keymaps = {
      accept_suggestion = "<Tab>",
      clear_suggestion = "<C-]>",
      accept_word = "<C-w>",
    },
  },
}
