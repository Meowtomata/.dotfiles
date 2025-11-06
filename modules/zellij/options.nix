{
  programs.zellij = {
    enable = true;
  };
  # https://github.com/zellij-org/zellij/blob/main/zellij-utils/assets/config/default.kdl
  xdg.configFile."zellij/config.kdl".text = ''
    keybinds {
        unbind "Alt f" "Alt o"

        normal {
            bind "Alt w" { ToggleFloatingPanes; }
        }
    }
  '';
}
