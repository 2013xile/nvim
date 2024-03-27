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
  -- {
  --   "goolord/alpha-nvim",
  --   opts = function(_, opts)
  --     -- customize the dashboard header
  --     opts.section.header.val = {
  --       " █████  ███████ ████████ ██████   ██████",
  --       "██   ██ ██         ██    ██   ██ ██    ██",
  --       "███████ ███████    ██    ██████  ██    ██",
  --       "██   ██      ██    ██    ██   ██ ██    ██",
  --       "██   ██ ███████    ██    ██   ██  ██████",
  --       " ",
  --       "    ███    ██ ██    ██ ██ ███    ███",
  --       "    ████   ██ ██    ██ ██ ████  ████",
  --       "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
  --       "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
  --       "    ██   ████   ████   ██ ██      ██"
  --     }
  --     return opts
  --   end
  -- }, -- You can disable default plugins as follows:
  -- {"max397574/better-escape.nvim", enabled = false},
  --
  -- -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", {"javascriptreact"})
    end
  }, 
  -- {
  --   "windwp/nvim-autopairs",
  --   config = function(plugin, opts)
  --     require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom autopairs configuration such as custom rules
  --     local npairs = require "nvim-autopairs"
  --     local Rule = require "nvim-autopairs.rule"
  --     local cond = require "nvim-autopairs.conds"
  --     npairs.add_rules({
  --       Rule("$", "$", {"tex", "latex"}) -- don't add a pair if the next character is %
  --       :with_pair(cond.not_after_regex "%%") -- don't add a pair if  the previous character is xxx
  --       :with_pair(cond.not_before_regex("xxx", 3)) -- don't move right when repeat character
  --       :with_move(cond.none()) -- don't delete if the next character is xx
  --       :with_del(cond.not_after_regex "xx") -- disable adding a newline when you press <cr>
  --       :with_cr(cond.none())
  --     }, -- disable for .vim files, but it work for another filetypes
  --     Rule("a", "a", "-vim"))
  --   end
  -- },
  {"olimorris/onedarkpro.nvim", priority = 1000}, {
    "zbirenbaum/copilot.lua",
    -- cmd = "Copilot",
    -- event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {suggestion = {enabled = false}, panel = {enabled = false}}
      }
    end
  }, {
    "zbirenbaum/copilot-cmp",
    event = {"InsertEnter", "LspAttach"},
    dependencies = {"zbirenbaum/copilot.lua"},
    config = function() require("copilot_cmp").setup() end
  }, {
    "hrsh7th/nvim-cmp",
    dependencies = {"zbirenbaum/copilot-cmp"},
    opts = function(_, opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local lspkind = require "lspkind"
      -- local has_words_before = function()
      --   local cursor = vim.api.nvim_win_get_cursor(0)
      --   return
      --       (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or
      --           ''):sub(cursor[2], cursor[2]):match('%s')
      -- end
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
                   vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match "^%s*$" ==
                   nil
      end
      opts.sources = cmp.config.sources {
        {name = "nvim_lsp", priority = 1000},
        {name = "luasnip", priority = 750}, {name = "buffer", priority = 500},
        {name = "path", priority = 250}, {name = "copilot", priority = 1250}
      }
      opts.formatting = {
        format = lspkind.cmp_format {
          mode = "symbol",
          max_width = 50,
          symbol_map = {Copilot = ""}
        }
      }
      -- modify the mapping part of the table
      -- opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
      --   if require("copilot.suggestion").is_visible() then
      --     require("copilot.suggestion").accept()
      --   elseif cmp.visible() then
      --     cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
      --   elseif luasnip.expandable() then
      --     luasnip.expand()
      --   elseif has_words_before() then
      --     cmp.complete()
      --   else
      --     fallback()
      --   end
      -- end, {"i", "s"})
      opts.mapping["<Tab>"] = vim.schedule_wrap(function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item {behavior = cmp.SelectBehavior.Select}
        else
          fallback()
        end
      end)
      return opts
    end
  }, {
    "David-Kunz/jester",
    config = function()
      require("jester").setup {cmd = "yarn test -t '$result' -- $file"}
    end
  }, {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = {"markdown"} end,
    ft = {"markdown"}
  }, {
    "xilesun/clipboard-image.nvim",
    config = function()
      require("clipboard-image").setup {
        default = {img_dir = {"%:p:h", "static"}, img_dir_txt = "./static"}
      }
    end
  }, {"nvim-neotest/nvim-nio"}
}
