---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    servers = { "pylance" },
    ---@diagnostic disable: missing-fields
    config = {
      clangd = { capabilities = { offsetEncoding = "utf-8" } },
      gopls = {
        settings = {
          gopls = {
            codelenses = {
              generate = true, -- show the `go generate` lens.
              gc_details = true, -- Show a code lens toggling the display of gc's choices.
              test = true,
              tidy = true,
              vendor = true,
              regenerate_cgo = true,
              upgrade_dependency = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            semanticTokens = true,
          },
        },
      },
      julials = { autostart = false },
      lua_ls = { settings = { Lua = { hint = { enable = true, arrayIndex = "Disable" } } } },
      pylance = {
        filetypes = { "python" },
        root_dir = function(...)
          return require("lspconfig.util").root_pattern(unpack {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "pyrightconfig.json",
            ".git",
          })(...)
        end,
        cmd = { "pylance", "--stdio" },
        single_file_support = true,
        before_init = function(_, c) c.settings.python.pythonPath = vim.fn.exepath "python" end,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "basic",
              autoImportCompletions = true,
              completeFunctionParens = true,
              indexing = true,
              inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
                callArgumentNames = true,
                pytestParameters = true,
              },
              stubPath = vim.env.HOME .. "/typings",
              diagnosticSeverityOverrides = {
                reportUnusedImport = "information",
                reportUnusedFunction = "information",
                reportUnusedVariable = "information",
                reportGeneralTypeIssues = "none",
                reportOptionalMemberAccess = "none",
                reportOptionalSubscript = "none",
                reportPrivateImportUsage = "none",
              },
            },
          },
        },
        handlers = {
          ["workspace/executeCommand"] = function(_, result)
            if result and result.label == "Extract Method" then
              vim.ui.input({ prompt = "New name: ", default = result.data.newSymbolName }, function(input)
                if input and #input > 0 then vim.lsp.buf.rename(input) end
              end)
            end
          end,
        },
        commands = {
          PylanceExtractMethod = {
            function()
              local arguments =
                { vim.uri_from_bufnr(0):gsub("file://", ""), require("vim.lsp.util").make_given_range_params().range }
              vim.lsp.buf.execute_command { command = "pylance.extractMethod", arguments = arguments }
            end,
            description = "Extract Method",
            range = 2,
          },
          PylanceExtractVariable = {
            function()
              local arguments =
                { vim.uri_from_bufnr(0):gsub("file://", ""), require("vim.lsp.util").make_given_range_params().range }
              vim.lsp.buf.execute_command { command = "pylance.extractVariable", arguments = arguments }
            end,
            description = "Extract Variable",
            range = 2,
          },
        },
        docs = {
          description = "https://github.com/microsoft/pylance-release\n\n`pylance`, Fast, feature-rich language support for Python",
        },
      },
      taplo = { evenBetterToml = { schema = { catalogs = { "https://www.schemastore.org/api/json/catalog.json" } } } },
      texlab = {
        on_attach = function(_, bufnr)
          require("astrocore").set_mappings({
            n = {
              ["<Leader>lB"] = { "<Cmd>TexlabBuild<CR>", desc = "LaTeX Build" },
              ["<Leader>lF"] = { "<Cmd>TexlabForward<CR>", desc = "LaTeX Forward Search" },
            },
          }, { buffer = bufnr })
        end,
        settings = {
          texlab = {
            build = { onSave = true },
            forwardSearch = { executable = "zathura", args = { "--synctex-forward", "%l:1:%f", "%p" } },
          },
        },
      },
      vtsls = {
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true, suppressWhenTypeMatchesName = false },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
            updateImportsOnFileMove = { enabled = "always" },
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true, suppressWhenTypeMatchesName = false },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
            updateImportsOnFileMove = { enabled = "always" },
          },
        },
      },
    },
    diagnostics = { update_in_insert = false },
    mappings = {
      i = {
        ["<C-l>"] = {
          function() vim.lsp.buf.signature_help() end,
          desc = "Signature help",
          cond = "textDocument/signatureHelp",
        },
      },
    },
  },
}
