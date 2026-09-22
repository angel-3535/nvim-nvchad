local M = {}

local config_file_name = "nvim-project-runner.json"

local function trim(value)
  return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function git_project()
  local start = vim.api.nvim_buf_get_name(0)
  if start == "" then
    start = vim.uv.cwd()
  elseif vim.fn.isdirectory(start) == 0 then
    start = vim.fs.dirname(start)
  end

  local result = vim.system(
    { "git", "-C", start, "rev-parse", "--show-toplevel", "--absolute-git-dir" },
    { text = true }
  ):wait()

  if result.code ~= 0 then
    vim.notify("Project runner: the current buffer is not in a Git project", vim.log.levels.WARN)
    return nil
  end

  local lines = vim.split(trim(result.stdout or ""), "\n", { plain = true })
  if #lines < 2 then
    vim.notify("Project runner: could not find this project's Git directory", vim.log.levels.ERROR)
    return nil
  end

  return {
    root = lines[1],
    config = vim.fs.joinpath(lines[2], config_file_name),
  }
end

local function load_commands(project)
  local file = io.open(project.config, "r")
  if not file then
    return {}
  end

  local contents = file:read("*a")
  file:close()

  local ok, commands = pcall(vim.json.decode, contents)
  if not ok or type(commands) ~= "table" then
    vim.notify("Project runner: invalid config at " .. project.config, vim.log.levels.ERROR)
    return nil
  end

  return commands
end

local function save_commands(project, commands)
  local file, err = io.open(project.config, "w")
  if not file then
    vim.notify("Project runner: " .. err, vim.log.levels.ERROR)
    return false
  end

  file:write(vim.json.encode(commands))
  file:write("\n")
  file:close()
  return true
end

local function with_project(callback)
  local project = git_project()
  if not project then
    return
  end

  local commands = load_commands(project)
  if not commands then
    return
  end

  callback(project, commands)
end

local function choose(commands, prompt, callback)
  vim.ui.select(commands, {
    prompt = prompt,
    format_item = function(command)
      return string.format("%d. %s", command.index, command.value)
    end,
  }, callback)
end

local function indexed(commands)
  local items = {}
  for index, value in ipairs(commands) do
    items[index] = { index = index, value = value }
  end
  return items
end

local function run_in_terminal(project, command)
  vim.cmd("botright vnew")

  local job = vim.fn.jobstart(command, {
    cwd = project.root,
    term = true,
  })

  if job <= 0 then
    vim.notify("Project runner: failed to start command", vim.log.levels.ERROR)
    vim.cmd("close")
    return
  end

  vim.api.nvim_buf_set_name(
    0,
    string.format("project-runner://%s/%d", vim.fn.fnamemodify(project.root, ":t"), job)
  )
  vim.cmd("startinsert")
end

function M.run(number)
  with_project(function(project, commands)
    if number then
      local command = commands[number]
      if not command then
        vim.notify(string.format("Project runner: no command saved at %d", number), vim.log.levels.WARN)
        return
      end
      run_in_terminal(project, command)
      return
    end

    if #commands == 0 then
      M.add()
    elseif #commands == 1 then
      run_in_terminal(project, commands[1])
    else
      choose(indexed(commands), "Run project command", function(choice)
        if choice then
          run_in_terminal(project, choice.value)
        end
      end)
    end
  end)
end

function M.add(command)
  with_project(function(project, commands)
    local function add(value)
      value = value and trim(value) or ""
      if value == "" then
        return
      end

      table.insert(commands, value)
      if save_commands(project, commands) then
        vim.notify(string.format("Project runner: saved as command %d", #commands))
      end
    end

    if command and command ~= "" then
      add(command)
    else
      vim.ui.input({ prompt = "Bash command: " }, add)
    end
  end)
end

function M.edit(number)
  with_project(function(project, commands)
    if #commands == 0 then
      vim.notify("Project runner: no commands to edit", vim.log.levels.WARN)
      return
    end

    local function edit(choice)
      if not choice then
        return
      end

      vim.ui.input({ prompt = "Edit command: ", default = choice.value }, function(value)
        value = value and trim(value) or ""
        if value == "" then
          return
        end
        commands[choice.index] = value
        if save_commands(project, commands) then
          vim.notify(string.format("Project runner: updated command %d", choice.index))
        end
      end)
    end

    if number then
      if not commands[number] then
        vim.notify(string.format("Project runner: no command saved at %d", number), vim.log.levels.WARN)
        return
      end
      edit({ index = number, value = commands[number] })
    else
      choose(indexed(commands), "Edit project command", edit)
    end
  end)
end

function M.delete(number)
  with_project(function(project, commands)
    if #commands == 0 then
      vim.notify("Project runner: no commands to delete", vim.log.levels.WARN)
      return
    end

    local function remove(choice)
      if not choice then
        return
      end
      table.remove(commands, choice.index)
      if save_commands(project, commands) then
        vim.notify(string.format("Project runner: deleted command %d", choice.index))
      end
    end

    if number then
      if not commands[number] then
        vim.notify(string.format("Project runner: no command saved at %d", number), vim.log.levels.WARN)
        return
      end
      remove({ index = number, value = commands[number] })
    else
      choose(indexed(commands), "Delete project command", remove)
    end
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("ProjectRun", function(opts)
    M.run(opts.args ~= "" and tonumber(opts.args) or nil)
  end, {
    nargs = "?",
    desc = "Run a saved command for this Git project",
  })

  vim.api.nvim_create_user_command("ProjectRunAdd", function(opts)
    M.add(opts.args)
  end, {
    nargs = "*",
    desc = "Add a command for this Git project",
  })

  vim.api.nvim_create_user_command("ProjectRunEdit", function(opts)
    M.edit(opts.args ~= "" and tonumber(opts.args) or nil)
  end, {
    nargs = "?",
    desc = "Edit a command for this Git project",
  })

  vim.api.nvim_create_user_command("ProjectRunDelete", function(opts)
    M.delete(opts.args ~= "" and tonumber(opts.args) or nil)
  end, {
    nargs = "?",
    desc = "Delete a command for this Git project",
  })

  vim.keymap.set("n", "<leader>r", M.run, { desc = "Run project command" })
  vim.keymap.set("n", "<leader>ra", M.add, { desc = "Add project command" })
  vim.keymap.set("n", "<leader>re", M.edit, { desc = "Edit project command" })
  vim.keymap.set("n", "<leader>rd", M.delete, { desc = "Delete project command" })

  for number = 1, 9 do
    vim.keymap.set("n", "<leader>r" .. number, function()
      M.run(number)
    end, { desc = string.format("Run project command %d", number) })
  end
end

return M
