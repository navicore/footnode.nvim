local M = {}
local utils = require("footnote.utils")
local api = require("footnote.api")
local window = require("footnote.window")
local footnote = require("footnote.footnote")

function M.lookup_selection()
  local selected_text = utils.get_visual_selection()

  if not selected_text or selected_text == "" then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  local config = require("footnote").config

  vim.notify("Looking up: " .. selected_text, vim.log.levels.INFO)

  api.fetch_wikipedia(selected_text, config, function(results, err)
    if err or not results or #results == 0 then
      vim.notify("No Wikipedia results found for: " .. selected_text, vim.log.levels.WARN)
      return
    end

    window.show_wikipedia_result(results[1], function(entry)
      footnote.insert_footnote(entry, selected_text)
    end)
  end)
end

return M