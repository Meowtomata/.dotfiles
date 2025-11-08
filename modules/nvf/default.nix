{ ... }:

{
  imports = [
    ./options.nix
    ./additional.nix
    ./mappings.nix
    ./obsidian.nix
    ./ide.nix
  ];

  programs.nvf.enable = true;
}
