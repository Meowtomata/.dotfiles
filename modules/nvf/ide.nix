{ ... }:
{
  programs.nvf.settings.vim = {
    # Treesitter
    treesitter = {
      enable = true;
    };

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
    };

    # LSPs
    lsp = {
      # enable global lsp functionality
      enable = true;
      formatOnSave = true;
    };

    # Display error messages while coding and lint
    diagnostics = {
      enable = true;

      config = {
        # virtual_text = true;
        virtual_lines = true;
      };

      nvim-lint = {
        enable = true;

        # https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file
        linters_by_ft = {
          cpp = [ "cpplint" ];

        };
      };
    };

    languages = {
      python.enable = true;
      python.lsp.enable = true;
      python.treesitter.enable = true;

      html.enable = true;
      html.treesitter.enable = true;

      css.enable = true;
      css.lsp.enable = true;
      css.treesitter.enable = true;
      css.format.enable = true;
      css.format.type = "prettierd";

      ts.enable = true;
      ts.lsp.enable = true;
      ts.treesitter.enable = true;
      ts.format.enable = true;
      ts.format.type = "prettierd";
      ts.extraDiagnostics.enable = true;
      ts.extensions.ts-error-translator.enable = true;

      nix.enable = true;
      nix.lsp.enable = true;
      nix.treesitter.enable = true;
      nix.format.enable = true;
      nix.format.type = "nixfmt";
      nix.extraDiagnostics.enable = true;

      lua.enable = true;
      lua.lsp.enable = true;
      lua.treesitter.enable = true;
      lua.format.enable = true;
      lua.extraDiagnostics.enable = true;

      clang.enable = true;
      clang.lsp.enable = true;
      clang.treesitter.enable = true;

      # enable markdown language features
      markdown.enable = true;
      # markdown.lsp.enable = true;
      markdown.treesitter.enable = true;
      markdown.format.enable = true;
      # change formatter from atorcious default deno formatter
      markdown.format.type = "prettierd";
    };

  };
}
