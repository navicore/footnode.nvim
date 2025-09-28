local M = {}

function M.setup(config)
  vim.api.nvim_create_user_command("Footnote", function(opts)
    local subcommand = opts.args

    if subcommand == "lookup" then
      require("footnote.lookup").lookup_selection()
    else
      vim.notify("Unknown subcommand: " .. subcommand, vim.log.levels.ERROR)
    end
  end, {
    nargs = 1,
    complete = function()
      return { "lookup" }
    end,
    desc = "Footnote commands",
  })

  vim.api.nvim_create_user_command("FootnoteLookup", function()
    require("footnode.lookup").lookup_selection()
  end, {
    range = true,
    desc = "Lookup selected text and create footnote",
  })
end

return M