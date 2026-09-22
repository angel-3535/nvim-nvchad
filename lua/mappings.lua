require "nvchad.mappings"

local map = vim.keymap.set

-- Editing muscle memory from nvim-dotconfig.
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("n", "<C-b>", "<C-a>", { desc = "Increment number" })
map("v", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
map("v", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })
map("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })
map("v", "<leader>y", '"*y', { desc = "Yank to primary selection" })
map("t", "<C-q>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<leader>pv", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Search project text" })
map("n", "<leader>GP", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview Git hunk" })
map("n", "<leader>?", function()
  require("which-key").show { global = false }
end, { desc = "Buffer local keymaps" })

-- These override NvChad's Ctrl-h/j/k/l window navigation in normal mode.
map("n", "<leader>a", function()
  require("harpoon"):list():add()
end, { desc = "Harpoon add file" })
map("n", "<C-e>", function()
  local harpoon = require "harpoon"
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })
for index, key in ipairs { "<C-j>", "<C-k>", "<C-l>", "<C-h>" } do
  map("n", key, function()
    require("harpoon"):list():select(index)
  end, { desc = "Harpoon file " .. index })
end

require("angel.project_runner").setup()
require "angel.todo"
