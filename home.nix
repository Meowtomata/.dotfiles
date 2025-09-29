{ config, pkgs, ... }:

{
  home.username = "meowster";
  home.homeDirectory = "/home/meowster";
  programs.git.enable = true;
  home.stateVersion = "25.05";

  imports = [
    ./modules/hyprland/default.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = 1;
  };


  programs.bash = {
    enable = true;
    shellAliases = {
      lg="lazygit";
    };
  };

  programs.qutebrowser = {
    enable = true; 

    searchEngines = {
      DEFAULT = "https://startpage.com/sp/search?query={}";
    };


    settings = {
      colors.webpage.darkmode.enabled = true;
      content.blocking.enabled = true;
     };
  };
  	

  programs.git = {
    userName = "Meowtomata";
    userEmail = "its.anatoliy@gmail.com";
  };

  programs.nvf = {
    enable = true;

    # https://notashelf.github.io/nvf/options.html
    settings = {
      vim.viAlias = true;
      vim.lsp = {
        enable = true;
      };

      vim.utility = {
        oil-nvim = {
          enable = true;

          setupOpts = {
            view_options.show_hidden = true;
          };
        };
      };

      vim.extraPlugins = {
        vim-tmux-navigator = {
          package = pkgs.vimPlugins.vim-tmux-navigator;
        };
      };
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "M-a";

    baseIndex = 1;
    extraConfig = ''
        vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?'
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +''${vim_pattern}$'"
        bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
        bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
        bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
        bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
        tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
        if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
        if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

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

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
}
