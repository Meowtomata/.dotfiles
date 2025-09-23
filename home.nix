{ config, pkgs, ... }:

{
  home.username = "meowster";
  home.homeDirectory = "/home/meowster";
  programs.git.enable = true;
  home.stateVersion = "25.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };

  programs.qutebrowser = {
    enable = true; 

    settings = {
      colors.webpage.darkmode.enabled = true;
    };
  };	

  programs.git = {
    userName = "Meowtomata";
    userEmail = "its.anatoliy@gmail.com";
  };

  programs.nvf = {
    enable = true;

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
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
}
