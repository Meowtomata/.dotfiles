{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    fuzzel # application picker
    pavucontrol # volume control
    zathura # PDF viewer

    # GUI Apps
    bitwig-studio # DAW
    neovim # text editor
    kitty # terminal
    qutebrowser # browser
    obsidian
    sweethome3d.application # interior design app

    # Terminal Apps
    bitwarden-cli
    lazygit
    yazi
    tmux

    # utilities
    xwayland-satellite # needed for sweethome3d and qutebrowser
    wl-clipboard
    fzf # fuzzy search
    ripgrep # grep
    fd # probably used for something in neovim idk
    jq # json tool
    gcalcli # for google calendar sync
    bash
    prettierd
    nixfmt-rfc-style

    # linters
    # cpplint

    # android utilities
    android-tools
    jmtpfs
  ];
}
