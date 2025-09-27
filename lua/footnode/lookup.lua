local M = {}
local utils = require("footnode.utils")
local api = require("footnode.api")
local telescope = require("footnode.telescope")
local footnote = require("footnode.footnote")

function M.lookup_selection()
  local selected_text = utils.get_visual_selection()

  if not selected_text or selected_text == "" then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  vim.cmd("normal! gv")
  vim.cmd("normal! ")

  local config = require("footnode").config

  vim.notify("Looking up: " .. selected_text, vim.log.levels.INFO)

  api.fetch_all(selected_text, config, function(results)
    if not results or #results == 0 then
      vim.notify("No results found for: " .. selected_text, vim.log.levels.WARN)
      return
    end

    telescope.show_results(results, function(entry)
      footnote.insert_footnote(entry, selected_text)
    end)
  end)
end

return M