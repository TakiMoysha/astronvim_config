-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

--- ========================================= OPTIONS
-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

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

