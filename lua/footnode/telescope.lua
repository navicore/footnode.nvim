local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

local function format_entry(entry)
  if entry.source == "Dictionary" then
    local display = string.format("[%s] %s", entry.source, entry.word or "")
    if entry.part_of_speech then
      display = display .. " (" .. entry.part_of_speech .. ")"
    end
    return display
  elseif entry.source == "Wikipedia" then
    return string.format("[%s] %s", entry.source, entry.title or "")
  end
  return string.format("[%s]", entry.source)
end

local function format_preview(entry)
  local lines = {}

  if entry.source == "Dictionary" then
    table.insert(lines, "Dictionary Entry")
    table.insert(lines, "================")
    table.insert(lines, "")
    if entry.word then
      table.insert(lines, "Word: " .. entry.word)
    end
    if entry.part_of_speech then
      table.insert(lines, "Part of Speech: " .. entry.part_of_speech)
    end
    table.insert(lines, "")
    if entry.definition then
      table.insert(lines, "Definition:")
      local wrapped = vim.fn.split(entry.definition, "\n")
      for _, line in ipairs(wrapped) do
        table.insert(lines, "  " .. line)
      end
    end
    if entry.example then
      table.insert(lines, "")
      table.insert(lines, "Example:")
      local wrapped = vim.fn.split(entry.example, "\n")
      for _, line in ipairs(wrapped) do
        table.insert(lines, "  " .. line)
      end
    end
  elseif entry.source == "Wikipedia" then
    table.insert(lines, "Wikipedia Summary")
    table.insert(lines, "=================")
    table.insert(lines, "")
    if entry.title then
      table.insert(lines, "Title: " .. entry.title)
    end
    if entry.description then
      table.insert(lines, "Description: " .. entry.description)
    end
    table.insert(lines, "")
    if entry.extract then
      table.insert(lines, "Summary:")
      table.insert(lines, "")

      local words = vim.split(entry.extract, " ")
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
    if entry.url then
      table.insert(lines, "")
      table.insert(lines, "URL: " .. entry.url)
    end
  end

  return lines
end

function M.show_results(results, on_select)
  if #results == 0 then
    vim.notify("No results found", vim.log.levels.INFO)
    return
  end

  pickers.new({}, {
    prompt_title = "Lookup Results",
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          display = format_entry(entry),
          ordinal = format_entry(entry),
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry, status)
        local preview_lines = format_preview(entry.value)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview_lines)
        vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "markdown")
      end,
    }),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          on_select(selection.value)
        end
      end)
      return true
    end,
  }):find()
end

return M