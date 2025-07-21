-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- Customize None-ls sources
---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
      null_ls.builtins.formatting.gofmt,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.prettier.with {
        condition = function(utils)
          return utils.root_has_file ".prettierrc"
            or utils.root_has_file ".prettierrc.js"
            or utils.root_has_file ".prettierrc.json"
        end,
      },
      -- null_ls.builtins.formatting.lua_format
      --     .with({extra_args = {"--indent-width=2"}})
    }
    return config -- return final config table
  end,
}
