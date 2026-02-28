local wk = require("which-key")

wk.setup({
  preset = "modern",
  delay = 200,
  expand = 1,
})

wk.add({
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Go / LSP" },
  { "<leader>h", group = "Git Hunk" },
  { "<leader>b", group = "Buffers" },
  { "<leader>s", group = "Split" },
  { "<leader>t", group = "Terminal / Toggle" },
  { "<leader>d", group = "Diagnostics" },
})
