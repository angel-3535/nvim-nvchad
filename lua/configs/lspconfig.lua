local nv_lsp = require "nvchad.configs.lspconfig"
local nv_on_attach = nv_lsp.on_attach

nv_lsp.on_attach = function(client, bufnr)
  nv_on_attach(client, bufnr)
  local function map(mode, key, action, description)
    vim.keymap.set(mode, key, action, { buffer = bufnr, desc = description })
  end

  -- Override NvChad's buffer-local rename mapping so it cannot shadow the runner.
  map("n", "<leader>ra", require("angel.project_runner").add, "Add project command")
  map("n", "gl", vim.diagnostic.open_float, "Line diagnostics")
  map("n", "[d", function() vim.diagnostic.jump { count = -1, float = true } end, "Previous diagnostic")
  map("n", "]d", function() vim.diagnostic.jump { count = 1, float = true } end, "Next diagnostic")
  map("n", "K", vim.lsp.buf.hover, "LSP hover")
  map("n", "gr", vim.lsp.buf.references, "LSP references")
  map("n", "gs", vim.lsp.buf.signature_help, "LSP signature help")
  map("n", "<F2>", vim.lsp.buf.rename, "LSP rename")
  map("n", "<F4>", vim.lsp.buf.code_action, "LSP code action")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
  map("n", "<leader>gf", vim.lsp.buf.format, "LSP format")
  map({ "n", "x" }, "<leader>gF", function()
    vim.lsp.buf.format { async = true }
  end, "LSP format asynchronously")
  map("n", "<leader>od", function()
    vim.lsp.buf.definition {
      on_list = function(definitions)
        local definition = definitions.items[1]
        if not definition then return end
        vim.cmd "vsplit"
        vim.cmd.edit(vim.fn.fnameescape(definition.filename))
        vim.api.nvim_win_set_cursor(0, { definition.lnum, math.max(definition.col - 1, 0) })
      end,
    }
  end, "Open definition in vertical split")
end

nv_lsp.defaults()

local servers = { "html", "cssls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
