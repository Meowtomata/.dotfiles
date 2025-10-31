{
  config,
  pkgs,
  inputs,
  lib,
  # leetcode-tui,
  ...
}:

# https://nix-community.github.io/home-manager/options.xhtml
{
  home.username = "meowster";
  home.homeDirectory = "/home/meowster";
  programs.git.enable = true;
  home.stateVersion = "25.05";

  imports = [
    ./applications.nix
    #   ./modules/nvim
    inputs.nixCats.homeModules.default
    ./modules/niri
    ./modules/qutebrowser
    ./modules/bash
    ./modules/tmux
    # ./modules/test-logger.nix
    # ./modules/hyprland-logger.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  nixCats = {
    enable = true;
    packageNames = [ "nixCats" "regularCats" ];
  };


  programs.kitty = {
    enable = true;

    keybindings = {
      "alt+shift+o" = ''launch tmux split-window "nvim -c 'ObsidianSearch'"'';
    };
  };

  programs.git = {
    userName = "Meowtomata";
    userEmail = "its.anatoliy@gmail.com";
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
}
