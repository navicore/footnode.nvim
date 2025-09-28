local M = {}

local function create_floating_window()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Wikipedia ",
    title_pos = "center",
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_win_set_option(win, "wrap", true)
  vim.api.nvim_win_set_option(win, "linebreak", true)

  return buf, win
end

function M.show_wikipedia_result(result, on_accept)
  local buf, win = create_floating_window()

  local lines = {}

  table.insert(lines, "# " .. (result.title or ""))
  table.insert(lines, "")

  if result.description then
    table.insert(lines, "_" .. result.description .. "_")
    table.insert(lines, "")
  end

  if result.extract then
    local extract = result.extract
    local words = vim.split(extract, " ")
    local current_line = ""

    for _, word in ipairs(words) do
      if #current_line + #word + 1 > 80 then
        table.insert(lines, current_line)
        current_line = word
      else
        if current_line == "" then
          current_line = word
        else
          current_line = current_line .. " " .. word
        end
      end
    end
    if current_line ~= "" then
      table.insert(lines, current_line)
    end
  end

  if result.url then
    table.insert(lines, "")
    table.insert(lines, "---")
    table.insert(lines, "[View on Wikipedia](" .. result.url .. ")")
  end

  table.insert(lines, "")
  table.insert(lines, "---")
  table.insert(lines, "Press `y` to create footnote, `q` or `<Esc>` to cancel")

  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Key mappings
  local function close_window()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local function accept_result()
    close_window()
    on_accept(result)
  end

  vim.keymap.set("n", "q", close_window, { buffer = buf })
  vim.keymap.set("n", "<Esc>", close_window, { buffer = buf })
  vim.keymap.set("n", "y", accept_result, { buffer = buf })
  vim.keymap.set("n", "<CR>", accept_result, { buffer = buf })
end

return M