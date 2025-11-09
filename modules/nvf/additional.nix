{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    # https://notashelf.github.io/nvf/options.html

    utility = {
      oil-nvim = {
        enable = true;

        setupOpts = {
          view_options.show_hidden = true;
        };
      };

      leetcode-nvim = {
        enable = true;
        setupOpts = {
          picker.provider = "snacks-picker";
        };
      };
    };

    extraPlugins = {
      # plugin found on nixpkgs
      vim-tmux-navigator = {
        package = pkgs.vimPlugins.vim-tmux-navigator;
      };
    };
  };

  # for leetcode.nvim
  # apparently the default LSP does not like the typing library
  # and the typing library is used everywhere in LeetCode
  home.file.".local/share/nvf/leetcode/pyproject.toml" = {
    text = ''
      [tool.basedpyright]
      reportDeprecated = "none"
    '';
  };
}
