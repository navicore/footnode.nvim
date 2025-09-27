local M = {}

M.config = {
  sources = {
    dictionary = {
      enabled = true,
      api_url = "https://api.dictionaryapi.dev/api/v2/entries/en/",
    },
    wikipedia = {
      enabled = true,
      api_url = "https://en.wikipedia.org/api/rest_v1/page/summary/",
    },
  },
  keymaps = {
    lookup = "<leader>fl",
  },
  footnote_format = "[^%d]: %s",
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  require("footnode.commands").setup(M.config)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      vim.keymap.set("v", M.config.keymaps.lookup, function()
        require("footnode.lookup").lookup_selection()
      end, { buffer = true, desc = "Lookup selection and create footnote" })
    end,
  })
end

return M