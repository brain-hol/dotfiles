-- options
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 4
vim.o.splitright = true

vim.o.signcolumn = "yes"
-- see help 'tabstop'
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.g.mapleader = " "

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "brainhol.plugins" },
  },
  change_detection = {
    notify = false,
  },
})

