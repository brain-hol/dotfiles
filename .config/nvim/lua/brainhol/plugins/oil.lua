return {
  "stevearc/oil.nvim",
  -- False so that Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  lazy = false,
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
}

