{
  config,
  pkgs,
  lib,
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

      binds = with config.lib.niri.actions; {

        "Mod+T" = {
          action = spawn "kitty";
        };
        "Mod+R" = {
          action = spawn "fuzzel";
        };
        "Mod+Q" = {
          action = close-window;
        };
        "Mod+Shift+E" = {
          action = quit;
        };

        # Moving focus
        "Mod+h" = {
          action = focus-column-left;
        };
        "Mod+j" = {
          action = focus-window-down;
        };
        "Mod+k" = {
          action = focus-window-up;
        };
        "Mod+l" = {
          action = focus-column-right;
        };

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        # Moving windows
        "Mod+Shift+h" = {
          action = move-column-left;
        };
        "Mod+Shift+j" = {
          action = move-window-down;
        };
        "Mod+Shift+k" = {
          action = move-window-up;
        };
        "Mod+Shift+l" = {
          action = move-column-right;
        };

        # Workspace management
        "Mod+1" = {
          action = focus-workspace 1;
        };
        "Mod+2" = {
          action = focus-workspace 2;
        };
        "Mod+3" = {
          action = focus-workspace 3;
        };
        "Mod+4" = {
          action = focus-workspace 4;
        };
        "Mod+5" = {
          action = focus-workspace 5;
        };
        "Mod+6" = {
          action = focus-workspace 6;
        };
        "Mod+7" = {
          action = focus-workspace 7;
        };
        "Mod+8" = {
          action = focus-workspace 8;
        };
        "Mod+9" = {
          action = focus-workspace 9;
        };

        # Column management
        "Mod+f" = {
          action = maximize-column;
        };
        "Mod+Shift+f" = {
          action = fullscreen-window;
        };
        "Mod+c" = {
          action = center-column;
        };

        "Mod+o" = {
          action = show-hotkey-overlay;
        };

        "Mod+N" = {
          action = spawn "sh" "-c" "echo \"lid open\" >> $HOME/bin/lid-open";
        };

        "XF86MonBrightnessUp" = {
          action = spawn "sh" "-c" "brightnessctl set 5%+";
        };
        "XF86MonBrightnessDown" = {
          action = spawn "sh" "-c" "brightnessctl set 5%-";
        };
        "XF86AudioRaiseVolume" = {
          action = spawn "sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        };
        "XF86AudioLowerVolume" = {
          action = spawn "sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        };
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

      # Workspace configuration remains the same.
      workspaces."1-Unstructured" = {
        name = "Unstructured";
      };
      workspaces."2-Coding" = {
        name = "Coding";
      };
      workspaces."3-HW" = {
        name = "HW";
      };
      workspaces."4-TA" = {
        name = "TA";
      };
      workspaces."5-Music" = {
        name = "Music Production";
      };
      workspaces."6-Video" = {
        name = "Video Production";
      };
      workspaces."7-Leisure" = {
        name = "Leisure";
      };
      workspaces."8-Config" = {
        name = "Configuration";
      };
      workspaces."9-Journal" = {
        name = "Journal";
      };
    };
  };
}
