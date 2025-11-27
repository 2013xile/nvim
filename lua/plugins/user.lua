-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:
---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  -- "andweeb/presence.nvim", {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require("lsp_signature").setup() end
  -- }, -- == Examples of Overriding Plugins ==
  -- -- customize alpha options
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require "alpha"
      local dashboard = require "alpha.themes.dashboard"

      local logo = [[
 __  __     __     __         ______    
/\_\_\_\   /\ \   /\ \       /\  ___\   
\/_/\_\/_  \ \ \  \ \ \____  \ \  __\   
  /\_\/\_\  \ \_\  \ \_____\  \ \_____\ 
  \/_/\/_/   \/_/   \/_____/   \/_____/ 
                                        
      ]]
      dashboard.section.header.val = vim.split(logo, "\n")
      alpha.setup(dashboard.config)
    end,
  },
  -- {"max397574/better-escape.nvim", enabled = false},
  --
  -- -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },
  { "olimorris/onedarkpro.nvim", priority = 1000 },
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "BufWinEnter",
    init = function() vim.g.copilot_no_maps = true end,
    config = function()
      -- vim.g.copilot_settings = {
      --   selectedCompletionModel = "claude-3.7-sonnet",
      -- }
      -- Block the normal Copilot suggestions
      vim.api.nvim_create_augroup("github_copilot", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
        group = "github_copilot",
        callback = function(args) vim.fn["copilot#On" .. args.event]() end,
      })
      vim.fn["copilot#OnFileType"]()
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      fuzzy = { implementation = "lua" },
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 1000,
            async = true,
          },
        },
      },
    },
  },
  -- {
  --   "David-Kunz/jester",
  --   config = function() require("jester").setup { cmd = "yarn test -t '$result' -- $file" } end,
  -- },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },
  {
    "xilesun/clipboard-image.nvim",
    config = function()
      require("clipboard-image").setup {
        default = { img_dir = { "%:p:h", "static" }, img_dir_txt = "./static" },
      }
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-vitest" {
            vitestCommand = "yarn test --",
            vitestArgs = {},
            cwd = function(path) return vim.fn.getcwd() end,
          },
        },
      }
    end,
  },
}
