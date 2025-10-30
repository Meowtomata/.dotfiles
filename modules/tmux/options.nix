{ ... }:
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "M-a";

    baseIndex = 1;

    # Smart pane switching with awareness of Vim splits.
    # See: https://github.com/christoomey/vim-tmux-navigator
    extraConfig = ''
        set-option -g allow-passthrough on
        set-option -g set-clipboard on

        vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?'
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +''${vim_pattern}$'"
        bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-h'  'select-pane -L'
        bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-j'  'select-pane -D'
        bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-k'  'select-pane -U'
        bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-l'  'select-pane -R'
        tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
        if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
            "bind-key -n 'M-\\' if-shell \"$is_vim\" 'send-keys M-\\'  'select-pane -l'"
        if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
            "bind-key -n 'M-\\' if-shell \"$is_vim\" 'send-keys M-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'M-h' select-pane -L
      bind-key -T copy-mode-vi 'M-j' select-pane -D
      bind-key -T copy-mode-vi 'M-k' select-pane -U
      bind-key -T copy-mode-vi 'M-l' select-pane -R
      bind-key -T copy-mode-vi 'M-\' select-pane -l

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      set -s escape-time 0 
      set-option -g repeat-time 1000
    '';
  };
}
