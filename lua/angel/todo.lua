-- Project-scoped todo list
-- Opens a todo buffer unique to each project (based on git root or cwd)

local function get_project_root()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error == 0 and git_root ~= "" then
    return git_root
  end
  return vim.fn.getcwd()
end

local function get_todo_path()
  local root = get_project_root()
  -- Hash the project path to create a unique filename
  local project_name = root:gsub("/", "%%")
  local todo_dir = vim.fn.stdpath("data") .. "/project-todos"
  vim.fn.mkdir(todo_dir, "p")
  return todo_dir .. "/" .. project_name .. ".md"
end

local function open_todo()
  local todo_path = get_todo_path()

  -- If file doesn't exist, seed it with a template
  if vim.fn.filereadable(todo_path) == 0 then
    local root = get_project_root()
    local name = vim.fn.fnamemodify(root, ":t")
    local lines = {
      "# TODO - " .. name,
      "",
      "- [ ] ",
    }
    vim.fn.writefile(lines, todo_path)
  end

  -- Create buffer and load the todo file
  local buf = vim.fn.bufadd(todo_path)
  vim.fn.bufload(buf)
  vim.bo[buf].filetype = "markdown"

  -- Floating window dimensions
  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " TODO ",
    title_pos = "center",
  })

  -- Close with q
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })

  -- Position cursor at the end of the last line
  vim.cmd("normal! G$")
end

vim.api.nvim_create_user_command("Todo", open_todo, { desc = "Open project todo list" })
vim.keymap.set("n", "<leader>td", open_todo, { desc = "Open project todo" })

return {}
