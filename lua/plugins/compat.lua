return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.mapping["<C-b>"] = cmp.mapping.scroll_docs(-4)
      opts.mapping["<C-e>"] = cmp.mapping.abort()
    end,
  },
}
