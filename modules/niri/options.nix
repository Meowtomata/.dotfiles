{
  ...
}:

{

  imports = [
    # ./niri-workspace-tracker.nix
  ];

  programs.niri = {

    settings = {

      input.touchpad = {
        tap = false;
        natural-scroll = false;
      };

      # Basic appearance (enhanced with some QoL additions)
      layout = {
        gaps = 2;
        border.width = 2;
        border.active.color = "#89b4fa"; # Your active color
        border.inactive.color = "#4c4f69"; # Your inactive color
        always-center-single-column = true;
      };

      # Disable the primary (middle-click) clipboard to avoid accidental pastes
      clipboard.disable-primary = true;

      # Path for saved screenshots (the ones not copied to clipboard)
      screenshot-path = "~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S.png";

      # Set your keyboard layout
      input.keyboard.xkb.layout = "us";

    };
  };
}
