return {
  { 
    "Exafunction/codeium.vim",
    lazy=false,
    config = function()
      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true })
    end
  },
}
