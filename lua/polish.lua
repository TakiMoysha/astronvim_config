-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.o.colorcolumn = "100,120"

vim.opt.clipboard = ""
-- spellcheck, better use lsp (native checker check all ui)
vim.opt.spell = false

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

-- off expandtab for go files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "go" },
  callback = function() vim.opt.expandtab = false end,
})

-- Avoid modifying fugitive diff buffers
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "fugitive:///*//0/*" },
  callback = function()
    vim.opt_local.modifiable = false
    vim.opt_local.readonly = true
  end,
})
