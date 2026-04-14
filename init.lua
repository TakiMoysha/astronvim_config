-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  local result = vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
  if vim.v.shell_error ~= 0 then
    -- stylua: ignore
    vim.api.nvim_echo({ { ("Error cloning lazy.nvim:\n%s\n"):format(result), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
    vim.fn.getchar()
    vim.cmd.quit()
  end
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.opt.spelllang = "en,ru"
  vim.cmd.quit()
end

-- require "../options"
require "lazy_setup"
require "polish"

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

-- vim.o.guifont = "Iosevka Nerd Font Regular:h10"
-- vim.o.guifontwide = "Miracode:h9"
-- vim.o.guifont = "JetBrainsMono Nerd Font:h9" -- The font used in graphical neovim applications
vim.o.guifont = "FiraCode Nerd Font Mono:h9" -- The font used in graphical neovim applications
-- vim.o.guifont = "Iosevka Nerd Font Regular:h10" -- The font used in graphical neovim applications
-- vim.o.guifont = "GohuFont 14 Nerd Font Mono:h10" -- The font used in graphical neovim applications
-- vim.o.guifont = "BlexMono Nerd Font:h9" -- The font used in graphical neovim applications
-- vim.o.guifont = "Terminess Nerd Font Propo:h12" -- The font used in graphical neovim applications
-- vim.o.guifont = "Source Code Pro:h10" -- The font used in graphical neovim applications
-- vim.o.guifont = "Terminess Nerd Font:h10" -- The font used in graphical neovim applications
-- vim.o.guifont = "Miracode:h10" -- Minecraft-like font
