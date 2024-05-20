return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("neodev").setup({})

    local lspconfig = require "lspconfig"

    local default_setup = function(server)
      lspconfig[server].setup({
        capabilities = lsp_capabilities,
      })
    end

    require("mason").setup({})
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "bashls",
      },
      handlers = {
        default_setup,
      },
    })

    local cmp = require("cmp")

    cmp.setup({
      sources = {
        { name = "nvim_lsp" },
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
    })
  end,
}
