if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("footnode.nvim requires Neovim >= 0.7.0")
  return
end

if vim.g.loaded_footnode then
  return
end
vim.g.loaded_footnode = true