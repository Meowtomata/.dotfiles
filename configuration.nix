{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; 
  networking.wireless.iwd.enable = true;

  ## https://wiki.nixos.org/wiki/PipeWire
  services.pipewire = {
    jack.enable = true;
  };


  time.timeZone = "America/Chicago";

  services.libinput = {
    enable = true;
    touchpad.disableWhileTyping = true;
    touchpad.tapping = false;
    
  };

  programs.hyprland = {
    enable = true;
  };

  services.displayManager.ly.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default = {
        ids = ["*"];
        settings.main.capslock = "overload(meta, esc)";
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.meowster = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim     
    wget
    neovim
    kitty
    wofi
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
    davinci-resolve
    wl-clipboard
    waybar
    fzf
    tmux
  ];

  services.asusd.enable = true;
  services.supergfxd.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
}

# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
