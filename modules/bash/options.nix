{ ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      lg = "lazygit";
      le = "nvim leetcode.nvim";
      bat = "cat /sys/class/power_supply/BAT0/capacity";
      icat = "kitten icat";
    };

    initExtra = ''
      nvim-smart-picker() {
        nvim -c 'lua require("snacks.picker").smart({cwd="/home/meowster", hidden=true})'
      }
      nvim-grep-picker() {
        nvim -c 'lua require("snacks.picker").grep({cwd="/home/meowster", hidden=true})'
      }

      bind -x '"\ef": nvim-smart-picker'
      bind -r "\eg"
      bind -x '"\eg": nvim-grep-picker'
      bind -r "\ed"
      bind -x '"\ed": nvim -c ObsidianDailies'
      bind -x '"\eo": nvim -c ObsidianSearch'
      bind -x '"\en": nvim -c ObsidianNew'
    '';
  };
}
