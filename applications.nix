{
  pkgs,
  ...
}:
{
  programs.zellij.enable = true;

  home.packages = with pkgs; [
    fuzzel # application picker
    pavucontrol # volume control
    zathura # PDF viewer

    # GUI Apps
    bitwig-studio # DAW
    neovim # text editor
    kitty # terminal
    qutebrowser # browser
    sweethome3d.application # interior design app

    # Terminal Apps
    bitwarden-cli
    lazygit
    tmux

    # utilities
    xwayland-satellite # needed for apps like sweethome3d
    wl-clipboard
    fzf # fuzzy search
    ripgrep # grep
    fd # probably used for something in neovim idk
    jq # json tool
    gcalcli # for google calendar sync
    bash
    prettierd
    nixfmt-rfc-style

    # android utilities
    android-tools
    jmtpfs
  ];
}
