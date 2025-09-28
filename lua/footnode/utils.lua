local M = {}

function M.get_visual_selection()
  -- Save current registers
  local save_reg = vim.fn.getreg('"')
  local save_regtype = vim.fn.getregtype('"')

  -- Yank visual selection to unnamed register
  vim.cmd([[silent normal! y]])

  -- Get the yanked text
  local text = vim.fn.getreg('"')

  -- Restore previous register
  vim.fn.setreg('"', save_reg, save_regtype)

  -- Clean up whitespace
  if text then
    text = text:gsub("^%s+", ""):gsub("%s+$", "")
  end

  return text
end

function M.escape_for_url(str)
  if not str then
    return ""
  end
  return str:gsub("([^%w%-_.~])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
end

function M.parse_json(str)
  local ok, result = pcall(vim.json.decode, str)
  if ok then
    return result
  else
    return nil, result
  end
end

function M.get_next_footnote_number()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local max_num = 0
  for _, line in ipairs(lines) do
    for num in line:gmatch("%[%^(%d+)%]") do
      max_num = math.max(max_num, tonumber(num))
    end
  end

  return max_num + 1
end

return M