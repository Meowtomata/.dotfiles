{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.asus-zephyrus-gu603h
  ];

  # I configured home-manager here I think
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.meowster = {
      imports = [
        ../../home.nix
        inputs.nvf.homeManagerModules.default
        inputs.niri.homeModules.niri
      ];
    };
    backupFileExtension = "backup";
  };

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

  # fonts or something
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      dejavu_fonts
    ];

    fontconfig.enable = true;
  };

  environment.variables.NIXOS_OZONE_WL = "1";

  services.displayManager.ly.enable = true;

  # Change keymappings
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main.capslock = "esc";
    };
  };

  # Change touchpad behavior
  services.libinput = {
    enable = true;
    touchpad.disableWhileTyping = true;
    touchpad.tapping = false;
  };

  # Define a user account
  users.users.meowster = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
    ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    git

    # probably needed for zephyrus
    asusctl
    supergfxctl
    brightnessctl
  ];

  # probably useful to enable
  services.asusd.enable = true;
  services.supergfxd.enable = true;
  hardware.graphics.enable = true;
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
