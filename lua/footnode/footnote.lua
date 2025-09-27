local M = {}
local utils = require("footnode.utils")

local function format_footnote_content(entry)
  if entry.source == "Dictionary" then
    local content = entry.word or ""
    if entry.part_of_speech then
      content = content .. " (" .. entry.part_of_speech .. ")"
    end
    if entry.definition then
      content = content .. ": " .. entry.definition
    end
    if entry.example then
      content = content .. " Example: \"" .. entry.example .. "\""
    end
    return content .. " [Dictionary]"
  elseif entry.source == "Wikipedia" then
    local content = entry.title or ""
    if entry.extract then
      local summary = entry.extract
      if #summary > 200 then
        summary = summary:sub(1, 197) .. "..."
      end
      content = content .. ": " .. summary
    end
    if entry.url then
      content = content .. " <" .. entry.url .. ">"
    end
    return content .. " [Wikipedia]"
  end
  return ""
end

function M.insert_footnote(entry, selected_text)
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]

  local footnote_num = utils.get_next_footnote_number()
  local footnote_ref = "[^" .. footnote_num .. "]"
  local footnote_content = string.format("[^%d]: %s", footnote_num, format_footnote_content(entry))

  local lines = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)
  local line = lines[1]

  local search_start = math.max(0, col - #selected_text - 10)
  local search_end = math.min(#line, col + #selected_text + 10)
  local search_portion = line:sub(search_start + 1, search_end)

  local found_pos = search_portion:find(vim.pesc(selected_text), 1, true)
  if found_pos then
    local actual_pos = search_start + found_pos
    local new_line = line:sub(1, actual_pos + #selected_text - 1) .. footnote_ref .. line:sub(actual_pos + #selected_text)
    vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, { new_line })
  else
    local new_line = line:sub(1, col) .. selected_text .. footnote_ref .. line:sub(col + 1)
    vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, { new_line })
  end

  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  local last_line = vim.api.nvim_buf_get_lines(bufnr, total_lines - 1, total_lines, false)[1]

  if last_line ~= "" then
    vim.api.nvim_buf_set_lines(bufnr, total_lines, total_lines, false, { "" })
  end

  vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { footnote_content })

  vim.notify("Added footnote [^" .. footnote_num .. "]", vim.log.levels.INFO)
end

return M