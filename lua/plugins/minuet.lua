if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AI autocomplete: https://github.com/milanglacier/minuet-ai.nvim
--
-- По умолчанию выключен: ничего не запрашивается и ghost text не появляется,
-- пока не включишь вручную:
--   :MinuetEnable | :MinuetDisable | :MinuetToggle  (или <Leader>;)
-- Ручной вызов при этом работает всегда:
--   <C-Space> — открыть меню blink (в т.ч. с minuet), <A-]> — запросить ghost text.

local augroup = vim.api.nvim_create_augroup("UserMinuet", { clear = true })

local function sync_buffers(on)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then vim.b[buf].minuet_virtual_text_auto_trigger = on end
  end
end

local function set_enabled(on)
  vim.g.minuet_enabled = on
  sync_buffers(on)

  local ok, minuet = pcall(require, "minuet")
  if ok and minuet.config then
    minuet.config.blink.enable_auto_complete = on
    if not on then pcall(function() require("minuet.virtualtext").action.dismiss() end) end
  end

  vim.notify("Minuet: completions " .. (on and "enabled" or "disabled"), vim.log.levels.INFO)
end

---@type LazySpec
return {
  { import = "astrocommunity.ai.minuet-ai-nvim" },

  {
    "milanglacier/minuet-ai.nvim",
    main = "minuet",
    -- plugin is tiny and needs to be set up to own its keymaps/commands,
    -- so loading it eagerly keeps :Minuet* always available
    lazy = false,

    opts = {
      provider = "gemini",
      request_timeout = 2.5,
      throttle = 1000,
      debounce = 400,
      notify = "warn",

      -- inline ghost text (windsurf-like), gated by :MinuetEnable
      virtualtext = {
        auto_trigger_ft = {}, -- * we manage the trigger ourselves in `init`
        auto_trigger_ignore_ft = { "TelescopePrompt", "snacks_picker_input", "NvimTree", "oil" },
        show_on_completion_menu = false,
        keymap = {
          accept = "<A-w>", -- whole suggestion
          accept_line = "<A-a>", -- one line
          next = "<A-]>", -- also asks for a suggestion manually
          prev = "<A-[>",
          dismiss = "<A-e>",
        },
      },

      -- minuet inside blink menu: manual (<C-Space>) only until enabled
      blink = { enable_auto_complete = false },

      provider_options = {
        gemini = {
          model = "gemini-2.5-flash",
          api_key = "GEMINI_API_KEY", -- имя переменной окружения, не сам ключ
          stream = true,
          optional = {
            generationConfig = {
              maxOutputTokens = 256,
              thinkingConfig = { thinkingBudget = 0 }, -- no thinking = lower latency
            },
          },
        },
      },

      -- :Minuet change_preset ollama   -- local model
      -- :Minuet change_preset original -- back to the config above
      presets = {
        lmstudio = {
          provider = "openai_fim_compatible",
          n_completions = 1,
          context_window = 1024,
          request_timeout = 3,
          provider_options = {
            openai_fim_compatible = {
              api_key = "TERM", -- placeholder, local server ignores it
              name = "lmstudio",
              end_point = "http://localhost:1234/v1/completions",
              model = "qwen2.5-coder-7b-instruct",
              optional = { max_tokens = 128, top_p = 0.3 },
            },
          },
        },
      },
    },

    init = function()
      vim.g.minuet_enabled = false

      -- buffers opened while enabled must keep triggering
      vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
        group = augroup,
        callback = function(args)
          if vim.g.minuet_enabled then vim.b[args.buf].minuet_virtual_text_auto_trigger = true end
        end,
        desc = "minuet: auto trigger only when enabled",
      })
    end,

    config = function(_, opts)
      require("minuet").setup(opts)

      -- vim.api.nvim_create_user_command("MinuetEnable", function() set_enabled(true) end, { desc = "Enable minuet completions" })
      -- vim.api.nvim_create_user_command("MinuetDisable", function() set_enabled(false) end, { desc = "Disable minuet completions" })
      -- vim.api.nvim_create_user_command( "MinuetToggle", function() set_enabled(not vim.g.minuet_enabled) end, { desc = "Toggle minuet completions" })

      -- vim.keymap.set("n", "<Leader>;", "<cmd>MinuetToggle<CR>", { desc = "Toggle AI completions" })
      -- vim.keymap.set("n", "<Leader>;b", "<cmd>Minuet blink toggle<CR>", { desc = "Toggle AI in blink menu" })
      -- vim.keymap.set("n", "<Leader>;o", "<cmd>Minuet change_preset lmstudio<CR>", { desc = "AI: local model (lmstudio)" })
      -- vim.keymap.set("n", "<Leader>;g", "<cmd>Minuet change_preset original<CR>", { desc = "AI: cloud model (gemini)" })
    end,
  },
}
