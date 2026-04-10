if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- INFO: https://github.com/wgsl-analyzer/wgsl-analyzer/tree/743b687d1732947cbb1d8bd73ab41eff47bc42e8?tab=readme-ov-file
-- INFO: https://github.com/wgsl-analyzer/wgsl-analyzer/blob/f9ab311f/editors/code/README.md
--   rg define_import_path -g '*.wgsl' --sort path | sd '^([^:]*):#define_import_path (.*)' ' "$2":' .. workdir .. ' "$1",'

local function load_wgsl_imports()
  local workdir = vim.fn.expand "$WORKSPACE_DIR/projects/bevy/"
  if workdir == "" then return {} end

  local cmd = string.format(
    "cd %s && rg 'define_import_path' -g '*.wgsl' --sort path | sd '^([^:]*):#define_import_path (.*)' '$2@$1'",
    vim.fn.shellescape(workdir)
  )

  local output = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then return {} end

  local imports = {}
  for _, line in ipairs(output) do
    local import_alias, import_from = line:match "([^@]+)@(.+)"
    if import_alias and import_from then imports[import_alias] = "file://" .. workdir .. import_from end
  end

  return imports
end

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      treesitter = { ensure_installed = { "wgsl", "wgsl_bevy"  }}
    }
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "wgsl-analyzer" })
    end,
  },

  {
    "AstroNvim/astrolsp",
    -- optional = true,
    opts = {
      config = {
        wgsl_analyzer = {
          ---@diagnostic disable: missing-fields
          ---@type lspconfig.settings.wgls_analyzer
          settings = {
            ["wgsl-analyzer"] = {
              diagnostics = {
                typeErrors = true,
                nagaParsing = false,
                nagaValidation = true,
                nagaVersion = "main",
              },
              inlayHints = {
                typeVerbosity = "full",
              },
              -- wgsl-analyzer not working with customImports in latest versions
              -- it used to see full path of imports (`:LspInfo`)
              customImports = load_wgsl_imports(),
            },
          },
        },
      },
    },
    -- opts = function(_, opts)
    --   if not opts.handlers then opts.handlers = {} end
    --   if not opts.config then opts.config = {} end
    --
    --   opts.config = vim.tbl_deep_extend("force", opts.config, {
    --
    --     ---@diagnostic disable: missing-fields
    --     wgsl_analyzer = {
    --       settings = {
    --       --   ["wgsl_analyzer"] = {
    --           inlayHints = {
    --             enabled = true,
    --             typeHints = true,
    --             parameterHints = true,
    --             structLayoutHints = true,
    --           },
    --           preprocessor = {
    --             shaderDefs = {
    --               "VERTEX_TANGENTS",
    --               "VERTEX_NORMALS",
    --               "VERTEX_COLORS",
    --               "VERTEX_UVS",
    --               "SKINNED",
    --             },
    --           },
    --           customImports = load_wgsl_imports(),
    --         },
    --       },
    --     -- },
    --   })
    --
    --   return opts
    -- end,
  },
}
