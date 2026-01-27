{ ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      lg = "lazygit";
      le = "nvim leetcode.nvim";
      nvf-print-config = "nvf-print-config | nvim -c 'set filetype=lua'";
      battery = "cat /sys/class/power_supply/BAT0/capacity";
      icat = "kitten icat";
    };

    initExtra = # bash
      ''
        # Defined in ~/.dotfiles/modules/nvf/mappings.nix with luaConfigRC 
        bind -x '"\eo": nvim -c SmartObsidianSearch'
        bind -x '"\ef": nvim -c SmartFind'
        bind -r "\eg"
        bind -x '"\eg": nvim -c GrepFind'

        bind -x '"\ea": nvim -c lua\ Snacks.picker.projects\(\)'
        bind -r "\ed"
        bind -x '"\ed": nvim -c Obsidian\ dailies'
        bind -x '"\en": nvim -c Obsidian\ new'
      '';
  };
}
