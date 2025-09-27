{ config, pkgs, ... }:

{
  home.username = "meowster";
  home.homeDirectory = "/home/meowster";
  programs.git.enable = true;
  home.stateVersion = "25.05";

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
