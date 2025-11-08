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
        bind -x '"\ef": nvim -c SmartFind'
        bind -r "\eg"
        bind -x '"\eg": nvim -c GrepFind'
        bind -r "\ed"
        bind -x '"\ed": nvim -c Obsidian\ dailies'
        bind -x '"\eo": nvim -c Obsidian\ search'
        bind -x '"\en": nvim -c Obsidian\ new'
      '';
  };
}
