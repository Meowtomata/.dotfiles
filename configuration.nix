{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    # ./modules/niri/niri-logger-resume.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.wireless.iwd.enable = true;

  ## https://wiki.nixos.org/wiki/PipeWire
  services.pipewire = {
    jack.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  time.timeZone = "America/Chicago";

  services.libinput = {
    enable = true;
    touchpad.disableWhileTyping = true;
    touchpad.tapping = false;

  };

  # services.logind.lidSwitch = "ignore";
  # services.logind.lidSwitchDocked = "ignore";
  # services.logind.lidSwitch = "hibernate";

  programs.hyprland = {
    enable = false;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  fonts = {
    packages = with pkgs; [
      # A good default set of fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      # Another popular fallback font
      dejavu_fonts
    ];

    fontconfig.enable = true;
  };

  environment.variables.NIXOS_OZONE_WL = "1";

  services.displayManager.ly.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main.capslock = "esc";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.meowster = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  security.polkit.enable = true;

  # Add a rule to allow users in the "wheel" group to suspend the system.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.login1.suspend" &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  programs.firefox.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    kitty
    fuzzel
    # alacritty
    qutebrowser
    bitwarden-cli
    git
    asusctl
    supergfxctl
    brightnessctl
    lazygit
    obsidian
    pavucontrol
    bitwig-studio
    reaper
    wl-clipboard
    waybar
    fzf
    fd
    ripgrep
    jq
    socat
    tmux
    gcalcli
    calcurse
    calcure
    browsh
    zathura
    libvirt
    dnsmasq
    sweethome3d.application
    xwayland-satellite
    android-tools
    jmtpfs
    gcc
  ];

  services.asusd.enable = true;
  services.supergfxd.enable = true;

  hardware.graphics.enable = true;

  virtualisation.libvirtd.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";
}

# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
