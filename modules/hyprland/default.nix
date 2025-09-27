{ ... }:

{
  # Import all your Hyprland configuration files
  imports = [
    ./autostart.nix
    ./binds.nix
    ./input.nix
    ./monitors.nix
    ./options.nix
    ./rules.nix
    ./variables.nix
  ];

  # Enable the Hyprland Wayland compositor
  wayland.windowManager.hyprland = {
    enable = true;
  };
}
