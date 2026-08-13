if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

vim.o.colorcolumn = "100,120"

-- vim.opt.clipboard = "" -- see `:help clipboard-tool` and astrocore.lua:options
-- spellcheck, better use lsp (native checker check all ui, working not good)
-- vim.opt.spell = false

-- tab settings
-- vim.opt.shiftwidth = 4
-- vim.opt.tabstop = 4
-- vim.opt.softtabstop = 4

-- border offset when scrolling
vim.opt.scrolloff = 5

-- preferences
vim.opt.background = "dark"

--
vim.opt.completeopt = "menu,menuone,noselect,popup"

--
vim.opt.relativenumber = true
vim.opt.number = true

--     timeoutlen = 500,
--     undofile = false,
--     signcolumn = "auto",

--- ========================================= AUTO COMMANDS
-- DEBUG: move to astrolsp.lua
-- off expandtab for go files
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "go" },
--   callback = function() vim.opt.expandtab = false end,
-- })

-- DEBUG: move to astrolsp.lua
-- vim.api.nvim_create_autocmd({ "BufReadPost" }, {
--   pattern = { "fugitive:///*//0/*" },
--   callback = function()
--     vim.opt_local.modifiable = false
--     vim.opt_local.readonly = true
--   end,
-- })

--- ======================================
local utils = require "utils"

vim.api.nvim_create_user_command("DumpKeymap", utils.dump_keymap, {})

-- Delete without yanking
vim.keymap.set("n", "s", '"_d', { desc = "Delete without yanking" })
vim.keymap.set("n", "S", '"_d$', { desc = "Delete line without yanking" })

-- Ctrl+Shift+V для вставки из буфера во всех основных режимах
vim.keymap.set({ "i", "n", "v" }, "<c-s-v>", '"+p', { noremap = true, silent = true })

--- =====================================

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

-- vim.o.guifont = "JetBrainsMono Nerd Font:h9" -- The font used in graphical neovim applications
vim.o.guifont = "FiraCode Nerd Font Mono:h9" -- The font used in graphical neovim applications
-- vim.o.guifont = "Iosevka Nerd Font Regular:h10" -- The font used in graphical neovim applications
-- vim.o.guifont = "GohuFont 14 Nerd Font Mono:h10" -- The font used in graphical neovim applications
-- vim.o.guifont = "BlexMono Nerd Font:h9" -- The font used in graphical neovim applications
-- vim.o.guifont = "Terminess Nerd Font Propo:h12" -- The font used in graphical neovim applications
-- vim.o.guifont = "Source Code Pro:h10" -- The font used in graphical neovim applications
-- vim.o.guifont = "Terminess Nerd Font:h10" -- The font used in graphical neovim applications
-- vim.o.guifont = "Miracode:h10" -- Minecraft-like font
