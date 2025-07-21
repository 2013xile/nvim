-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- Customize Mason plugins
---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers（注意替换名称为 mason 中的标准名称）
        "lua-language-server", -- lua_ls => lua-language-server
        "clangd",
        "cmake-language-server",
        "css-lsp", -- cssls => css-lsp
        "dot-language-server", -- dotls => dot-language-server
        "dockerfile-language-server", -- dockerls => dockerfile-language-server
        "gopls",
        "html-lsp", -- html => html-lsp
        "json-lsp", -- jsonls => json-lsp
        "yaml-language-server", -- yamlls => yaml-language-server
        "marksman",
        "sqls", -- sqlls => sql-language-server
        "pyright",
        "tailwindcss-language-server", -- tailwindcss => tailwindcss-language-server
        "typescript-language-server", -- tsserver => typescript-language-server
        "eslint_d", -- eslint@4.8.0 => eslint_d（mason 不支持指定版本）
        "golangci-lint-langserver", -- golangci_lint_ls => golangci-lint-langserver
        "clojure-lsp",

        -- null-ls sources (格式化器/诊断)
        "prettier",
        "stylua",

        -- DAP 调试器
        "debugpy",
      },
      auto_update = true,
      run_on_start = true,
    },
  },
}
