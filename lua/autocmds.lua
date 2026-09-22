require "nvchad.autocmds"

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("angel-explorer-startup", { clear = true }),
  desc = "Open the file explorer on startup",
  callback = function()
    if #vim.api.nvim_list_uis() == 0 then return end

    vim.schedule(function()
      local window = vim.api.nvim_get_current_win()
      local editing_file = vim.bo.buftype == "" and vim.fn.expand "%" ~= ""
        and vim.fn.isdirectory(vim.fn.expand "%:p") == 0
      require("nvim-tree.api").tree.open()
      if editing_file and vim.api.nvim_win_is_valid(window) then
        vim.api.nvim_set_current_win(window)
      end
    end)
  end,
})
