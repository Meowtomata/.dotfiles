{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    # Treesitter
    treesitter = {
      enable = true;
    };

    theme.enable = true;
    theme.name = "everforest";
    theme.style = "hard";

    terminal.toggleterm.enable = true;
    mini.test.enable = true;

    # Autocompletion
    autocomplete.blink-cmp = {
      enable = true;

      setupOpts = {
        # Disables autocomplete when writing in markdown buffer
        # (by not including it below)
        sources.per_filetype.markdown = [
          "lsp"
          "path"
          "snippets"
        ];
      };

      sourcePlugins.ripgrep.enable = true;
    };

    # LSPs
    lsp = {
      # enable global lsp functionality
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      lspsaga.enable = true;

      # enables lsp & code completion for code blocks
      otter-nvim.enable = true;
    };

    # Display error messages while coding and lint
    diagnostics = {
      enable = true;

      config = {
        virtual_text = true;
      };

      nvim-lint = {
        enable = true;

        # https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file
        # linters_by_ft = {
        #   cpp = [ "cpplint" ];
        #
        # };
      };
    };

    # https://notashelf.github.io/nvf/options.html
    languages = {

      python = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };

      html.enable = true;
      html.treesitter.enable = true;

      css = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        format.enable = true;
        format.type = [ "prettierd" ];
      };

      ts = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        format.enable = true;
        format.type = [ "prettierd" ];
        extraDiagnostics.enable = true;
        extensions.ts-error-translator.enable = true;
      };

      nix = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        format.enable = true;
        format.type = [ "nixfmt" ];
        extraDiagnostics.enable = true;
      };

      lua = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        format.enable = true;
        extraDiagnostics.enable = true;
      };

      bash = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        format.enable = true;
        extraDiagnostics.enable = true;
      };

      clang = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };

      markdown = {
        # enable markdown language features
        enable = true;
        # make sure marksman.toml or .git exists in proj dir
        lsp.enable = true;
        # lsp.servers = "markdown-oxide";
        treesitter.enable = true;
        format.enable = true;
        extensions.render-markdown-nvim.enable = false;
        # change formatter from atorcious default deno formatter
        format.type = [ "prettierd" ];
      };
    };

    extraPlugins = {
      molten = {
        package = pkgs.vimPlugins.molten-nvim.overrideAttrs (old: {
          src = pkgs.fetchFromGitHub {
            owner = "benlubas";
            repo = "molten-nvim";
            rev = "4fd7be6a12b5efda5179db642f13bad60893acca";
            sha256 = "sha256-7+OXmwYue7nfE50836jkuxkviT761aHvH+Ca+zyMFPQ=";
          };

          nvimSkipModule = [
            "load_snacks_nvim"
            "load_wezterm_nvim"
            "load_image_nvim"
          ];
        });

        setup = # lua
          ''
            vim.g.molten_image_provider = "snacks.nvim"
            vim.g.molten_auto_image_popup = true
            vim.g.molten_wrap_output = true
            vim.g.molten_virt_text_output = true
            vim.g.molten_virt_lines_off_by_1 = true
          '';
      };

      quarto-nvim = {
        package = pkgs.vimPlugins.quarto-nvim;

        setup = # lua
          ''
            require('quarto').setup {
              debug = false,
              closePreviewOnExit = true,
              lspFeatures = {
                enabled = true,
                chunks = "curly",
                languages = { "r", "python", "julia", "bash", "html" },
                diagnostics = {
                  enabled = true,
                  triggers = { "BufWritePost" },
                },
                completion = {
                  enabled = true,
                },
              },
              codeRunner = {
                enabled = true,
                default_method = "molten",
                ft_runners = {},
                never_run = { 'yaml' },
              },
            }

          '';

        after = [
          "otter-nvim"
          "nvim-treesitter"
        ];
      };

    };

    withPython3 = true;

    luaPackages = [
      "magick"
    ];

    python3Packages = [
      "pynvim"
      "jupyter-client"
      "cairosvg"
      "pnglatex"
      "plotly"
      "pyperclip"
      "nbformat"
    ];

  };
}
