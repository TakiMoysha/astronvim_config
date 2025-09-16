-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.

local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
  vim.opt.spelllang='en,ru'
end

require "lazy_setup"
require "polish"

if vim.g.neovide then
  -- vim.o.guifont = "FiraCode Nerd Font Mono:h9"
  vim.o.guifont = "JetBrainsMono Nerd Font:h9"
  -- vim.o.guifont = "Iosevka Nerd Font Regular:h10" -- толстоват
  -- vim.o.guifont = "GohuFont 14 Nerd Font Mono:h9"
  -- vim.o.guifont = "BlexMono Nerd Font:h9"
  -- vim.o.guifont = "Terminess Nerd Font Propo:h10"
  -- vim.o.guifont = "Source Code Pro:h12"
end

-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     vim.notify("1: " .. vim.fn.argv())
--     if vim.g.neovide then
-- local rs = require "resession"
-- local last_session = rs.list()[0]
-- vim.notify("Resession: ", vim.log.levels.INFO)
-- rs.load(last_session)
-- end
--   end,
-- })
