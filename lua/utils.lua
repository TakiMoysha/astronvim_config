local M = {}

function M.dump_keymap()
  local export_filename = "nvim-keymaps.md"
  local file = io.open(vim.fn.expand(export_filename), "w")
  if not file then return end

  file:write "# Current Keymap Config\n\n"

  local modes = { "n", "i", "v", "x", "o", "c" }
  local mode_names = {
    n = "Normal",
    i = "Insert",
    v = "Visual",
    x = "Visual Block",
    o = "Operator-pending",
    c = "Command-line",
  }

  for _, mode in ipairs(modes) do
    file:write("## " .. mode_names[mode] .. " Mode\n\n")
    file:write "| Key | Mapping | Source | Description |\n"
    file:write "| --- | --- | --- | --- |\n"

    local mappings = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(mappings) do
      local lhs = map.lhs
      local rhs = map.rhs or "BAD_VALUE"
      local desc = map.desc or "not described"
      local src = map.script or "unknown"

      -- rhs = string.gsub(rhs, "<CR>", "")

      file:write("| `" .. lhs .. "` | `" .. rhs .. "` | `" .. src .. "` | `" .. desc .. "`|\n")
    end
    file:write "\n"
  end

  file:close()
  vim.notify("Keymap exported to" .. export_filename)
end

return M
