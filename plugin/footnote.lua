if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("footnote.nvim requires Neovim >= 0.7.0")
  return
end

if vim.g.loaded_footnote then
  return
end
vim.g.loaded_footnote = true