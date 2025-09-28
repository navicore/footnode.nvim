local M = {}
local utils = require("footnode.utils")

local function fetch_url(url, callback)
  local curl = require("plenary.curl")

  curl.get(url, {
    callback = vim.schedule_wrap(function(response)
      if response.status == 200 then
        callback(response.body)
      else
        callback(nil, "Request failed with status: " .. response.status)
      end
    end),
  })
end

function M.fetch_dictionary(word, config, callback)
  if not config.sources.dictionary.enabled then
    callback(nil, "Dictionary source is disabled")
    return
  end

  local url = config.sources.dictionary.api_url .. utils.escape_for_url(word)

  fetch_url(url, function(body, err)
    if err then
      callback(nil, err)
      return
    end

    local data, parse_err = utils.parse_json(body)
    if parse_err then
      callback(nil, parse_err)
      return
    end

    local results = {}
    if type(data) == "table" and data[1] then
      for i, entry in ipairs(data) do
        if i > 3 then break end

        if entry.meanings then
          for _, meaning in ipairs(entry.meanings) do
            if meaning.definitions then
              for j, def in ipairs(meaning.definitions) do
                if j > 2 then break end
                table.insert(results, {
                  source = "Dictionary",
                  word = entry.word,
                  part_of_speech = meaning.partOfSpeech,
                  definition = def.definition,
                  example = def.example,
                })
              end
            end
          end
        end
      end
    end

    callback(results)
  end)
end

function M.fetch_wikipedia(term, config, callback)
  local url = config.wikipedia.api_url .. utils.escape_for_url(term)

  fetch_url(url, function(body, err)
    if err then
      callback(nil, err)
      return
    end

    local data, parse_err = utils.parse_json(body)
    if parse_err then
      callback(nil, parse_err)
      return
    end

    local results = {}
    if data and data.extract then
      table.insert(results, {
        source = "Wikipedia",
        title = data.title or term,
        extract = data.extract,
        description = data.description,
        url = data.content_urls and data.content_urls.desktop and data.content_urls.desktop.page,
      })
    end

    callback(results)
  end)
end

function M.fetch_all(term, config, callback)
  local all_results = {}
  local completed = 0
  local total = 2

  local function check_complete()
    completed = completed + 1
    if completed == total then
      callback(all_results)
    end
  end

  M.fetch_dictionary(term, config, function(results, err)
    if results then
      for _, result in ipairs(results) do
        table.insert(all_results, result)
      end
    end
    check_complete()
  end)

  M.fetch_wikipedia(term, config, function(results, err)
    if results then
      for _, result in ipairs(results) do
        table.insert(all_results, result)
      end
    end
    check_complete()
  end)
end

return M