local M = {}

function M.setup(config)
  vim.api.nvim_create_user_command("Footnode", function(opts)
    local subcommand = opts.args

    if subcommand == "lookup" then
      require("footnode.lookup").lookup_selection()
    else
      vim.notify("Unknown subcommand: " .. subcommand, vim.log.levels.ERROR)
    end
  end, {
    nargs = 1,
    complete = function()
      return { "lookup" }
    end,
    desc = "Footnode commands",
  })

  vim.api.nvim_create_user_command("FootnoteLookup", function()
    require("footnode.lookup").lookup_selection()
  end, {
    range = true,
    desc = "Lookup selected text and create footnote",
  })
end

return M