{ config, ... }:
{
  programs.niri = {
    settings = {

      # make sure laptop monitor is enabled
      outputs."eDP-1".enable = true;

      # config for external 240hz GSYNC 1080p monitor
      # but uhh I don't have a usb c to display port cable
      # so we're stuck with 60 hz and no gsync in the mean time
      outputs."HDMI-A-1" = {
        enable = true;
        # mode = {
        #   refresh = 240.0;
        #   height = 1920;
        #   width = 1080;
        # };
        # variable-refresh-rate = true;
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

        "Mod+s" = {
          action = spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy";
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
    };
  };
}
