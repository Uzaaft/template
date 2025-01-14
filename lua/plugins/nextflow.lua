---@type LazySpec
return {
  { "nextflow-io/vim-language-nextflow", ft = "nextflow" },
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    specs = {
      "nextflow-io/vscode-language-nextflow",
      commit = "efc410e46db3518ec7693668e159fb7b148a0e1a",
      ft = "nextflow",
      dependencies = { "L3MON4D3/LuaSnip" },
      config = function(plugin)
        require("luasnip.loaders.from_vscode").lazy_load {
          paths = { plugin.dir },
        }
      end,
    },
  },
  {
    "echasnovski/mini.snippets",
    optional = true,
    opts = {
      snippets = {
        function(context)
          if context.lang == "nextflow" then
            return require("mini.snippets").read_file(
              require("astrocore").get_plugin("vscode-language-nextflow").dir .. "/snippets/snippets.json"
            )
          end
        end,
      },
    },
    specs = {
      "nextflow-io/vscode-language-nextflow",
      commit = "efc410e46db3518ec7693668e159fb7b148a0e1a",
      lazy = true,
    },
  },
}
