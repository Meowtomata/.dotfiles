{
  pkgs,
  ...
}:
{
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
  };

  home.packages = with pkgs; [
    fuzzel # application picker
    pavucontrol # volume control
    zathura # PDF viewer

    # GUI Apps
    bitwig-studio # DAW
    neovim # text editor
    kitty # terminal
    obsidian
    sweethome3d.application # interior design app
    libreoffice-qt6-fresh # idk why it's qt6 and fresh
    spotify
    nexusmods-app # for stardew mods
    gimp # for photo editing
    krita # also for photo editing
    firefox # for if qutebrowser breaks
    racket # for SICP LISP testing
    audacity # for recording
    kdePackages.kdenlive # for editing
    opentabletdriver # for wacom tablet
    input-remapper # for extending binds of wacom tablet
    nicotine-plus # for music sharing

    # Terminal Apps
    bitwarden-cli
    lazygit
    yazi
    tmux

    # utilities
    xwayland-satellite # needed for sweethome3d and qutebrowser
    #xclip
    wl-clipboard
    fzf # fuzzy search
    ripgrep # grep
    fd # probably used for something in neovim idk
    jq # json tool
    gcalcli # for google calendar sync
    bash
    prettierd
    nixfmt-rfc-style
    quarto # for quarto-nvim
    gh # for snacks gh
    ghostscript # for snacks pdf rendering
    texliveFull # for latex
    grim # screenshots?
    slurp # screenshots?
    mpv # watch videos through yazi
    docker # docker

    # coding?
    gcc # c/c++ compiler
    gnumake # makefile
    nasm # intel assembly

    # linters
    # cpplint

    # android utilities
    android-tools
    jmtpfs
  ];
}
