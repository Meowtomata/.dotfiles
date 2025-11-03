{ ... }:
{
  programs.nvf.settings.vim = {
    # Treesitter
    treesitter = {
      enable = true;
    };

    # Autocompletion
    autocomplete.blink-cmp = {
      enable = true;

    };

    # LSPs
    lsp = {
      # enable global lsp functionality
      enable = true;
      formatOnSave = true;
    };

    languages = {
      python.enable = true;

      nix.enable = true;
      nix.lsp.enable = true;
      nix.treesitter.enable = true;
      nix.format.enable = true;
      nix.format.type = "nixfmt";

      clang.enable = true;

      # enable markdown language features
      markdown.enable = true;
      markdown.lsp.enable = true;
      markdown.treesitter.enable = true;
      markdown.format.enable = true;
      # change formatter from atorcious default deno formatter
      markdown.format.type = "prettierd";
    };

  };
}
