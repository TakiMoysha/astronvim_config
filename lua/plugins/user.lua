---@type LazySpec
return {
  { "EdenEast/nightfox.nvim" },
  { "loctvl842/monokai-pro.nvim" },
  { "wakatime/vim-wakatime", lazy = false, optsd = { status_bar_enabled = true } },

  -- {
  --  TODO: delete
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require("lsp_signature").setup() end,
  -- },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      dashboard = { enabled = true },
      picker = {
        win = {
          preview = {
            wo = { wrap = true },
          },
        },
      },
      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
    },
  },

  -- { "max397574/better-escape.nvim", enabled = false }, -- TODO: delete

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "User AstroFile",
    cmd = { "TodoQuickFix" },
  },

  -- {
  -- TODO: delete
  --   "windwp/nvim-autopairs",
  --   config = function(plugin, opts)
  --     require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom autopairs configuration such as custom rules
  --     local npairs = require "nvim-autopairs"
  --     local Rule = require "nvim-autopairs.rule"
  --     local cond = require "nvim-autopairs.conds"
  --     npairs.add_rules(
  --       {
  --         Rule("$", "$", { "tex", "latex" })
  --           -- don't add a pair if the next character is %
  --           :with_pair(cond.not_after_regex "%%")
  --           -- don't add a pair if  the previous character is xxx
  --           :with_pair(
  --             cond.not_before_regex("xxx", 3)
  --           )
  --           -- don't move right when repeat character
  --           :with_move(cond.none())
  --           -- don't delete if the next character is xx
  --           :with_del(cond.not_after_regex "xx")
  --           -- disable adding a newline when you press <cr>
  --           :with_cr(cond.none()),
  --       },
  --       -- disable for .vim files, but it work for another filetypes
  --       Rule("a", "a", "-vim")
  --     )
  --   end,
  -- },

  {
    "AndrewRadev/switch.vim",
    keys = {
      { "gs", mode = { "n", "x" } },
    },
  },

  -- AI autocomplete
  {
    "Exafunction/windsurf.vim",
    event = "User AstroFile",
    config = function()
      vim.keymap.set("i", "<A-w>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<c-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<c-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<c-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
      vim.keymap.set("n", "<Leader>;", function()
        if vim.g.codeium_enabled == true then
          vim.cmd "CodeiumDisable"
        else
          vim.cmd "CodeiumEnable"
        end
      end, { noremap = true, desc = "Toggle Codeium active" })
    end,
  },

  --
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.completion = opts.completion or {}
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.draw = opts.completion.menu.draw or {}

      opts.completion.menu.draw.columns = {
        { "kind_icon" },
        { "label", "label_description", gap = 1 },
        { "source_name" },
      }

      opts.completion.menu.draw.components = opts.completion.menu.draw.components or {}
      opts.completion.menu.draw.components.source_name = {
        text = function(ctx) return ctx.item.source_name end,
        highlight = "BlinkCmpSource",
      }

      --- try remove angular snippets, unsuccessful
      -- opts.sources = opts.sources or {}
      -- opts.sources.providers = opts.sources.providers or {}
      -- opts.sources.providers.snippets = opts.sources.providers.snippets or {}
      -- opts.sources.providers.snippets.filter_snippets = function(ft, file)
      --   -- ignore angular snippets
      --   return not (string.match(file, "friendly.snippets") and string.match(file, "angular"))
      -- end
    end,
  },

  --
  {
    "vyfor/cord.nvim",
    branch = "master",
    build = ":Cord update",
    event = "VeryLazy",
    enabled = true,
    config = function()
      require("cord").setup {
        timestamp = {
          enabled = true,
          reset_on_idle = false,
          reset_on_change = false,
        },
        editor = {
          client = "astronvim",
        },
        idle = {
          unidle_on_focus = false,
          ignore_focus = true,
          tooltip = "💤",
        },
        text = {
          viewing = "Viewing {}",
          editing = function(opts)
            if opts.filetype == "rust" then return "🦀 Rusting..." end
            return "Editing " .. opts.filename
          end,
          lsp = "LSP:{}",
          dashboard = "Dashboard:Home",
        },
        buttons = {
          {
            label = function(opts) return opts.repo_url and "Repository" or "Website" end,
            url = function(opts) return opts.repo_url or "https://github.com/takimoysha" end,
          },
        },
      }
    end,
  },

  -- executor
  {
    "google/executor.nvim",
    cmd = {
      "ExecutorRun",
      "ExecutorSetCommand",
      "ExecutorShowDetail",
      "ExecutorHideDetail",
      "ExecutorToggleDetail",
      "ExecutorSwapToSplit",
      "ExecutorSwapToPopup",
      "ExecutorToggleDetail",
      "ExecutorReset",
    },
    opts = {
      use_split = true,
      popup = {
        -- Sets the width of the popup to 3/5ths of the screen's width.
        width = math.floor(vim.o.columns * 6 / 10),
        -- Sets the height to almost full height, allowing for some padding.
        height = vim.o.lines - 20,
        -- Border styles
        border = {
          padding = {
            top = 1,
            bottom = 1,
            left = 0,
            right = 0,
          },
          style = "rounded",
        },
      },
    },
    dependencies = {
      { "MunifTanjim/nui.nvim" },
      {
        "AstroNvim/astrolsp",
        opts = function(_, opts)
          ---@type AstroLSPOpts
          local opts = opts
          opts.mappings.n["<F2>"] = { "<Cmd>ExecutorRun<CR>", desc = "Execute" }
          opts.mappings.n["<Leader>Ee"] = { "<Cmd>ExecutorRun<CR>", desc = "Execute" }
          opts.mappings.n["<Leader>Es"] = { "<Cmd>ExecutorSetCommand<CR>", desc = "Set command" }
          opts.mappings.n["<Leader>Et"] = { "<Cmd>ExecutorToggleDetail<CR>", desc = "Toggle Detail" }
          opts.mappings.n["<F8>"] = { "<Cmd>ExecutorToggleDetail<CR>", desc = "Toggle Detail" }
          opts.mappings.n["<Leader>ES"] = { "<Cmd>ExecutorSwapToSplit<CR>", desc = "Swap to Split" }
          opts.mappings.n["<Leader>EP"] = { "<Cmd>ExecutorSwapToPopup<CR>", desc = "Swap to Popup" }
          opts.mappings.n["<Leader>Eh"] = { "<Cmd>ExecutorShowHistory<CR>", desc = "Show history" }
          opts.mappings.n["<Leader>Er"] = { "<Cmd>ExecutorReset<CR>", desc = "Clear the stored commands and output" }
          opts.mappings.n["<Leader>E"] = { desc = "Executor" }
        end,
      },
    },
  },

  {
    "pustota-theme/pustota.nvim",
    version = "*",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
