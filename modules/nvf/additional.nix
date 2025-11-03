{ pkgs, ... }:
{
  programs.nvf = {
    enable = true;

    # https://notashelf.github.io/nvf/options.html
    settings = {

      vim.binds.whichKey.enable = true;

      vim.keymaps = [
        {
          key = "<Tab>";
          mode = [ "n" ];
          action = "<cmd>bn<cr>";
          silent = true;
        }
        {
          key = "<S-Tab>";
          mode = [ "n" ];
          action = "<cmd>bp<cr>";
          silent = true;
        }
        # Oil
        {
          key = "-";
          mode = [ "n" ];
          action = "<cmd>Oil<cr>";
          silent = true;
        }
      ];

      vim.utility = {
        oil-nvim = {
          enable = true;

          setupOpts = {
            view_options.show_hidden = true;
          };
        };

        # used by leetcode-nvim
        images.image-nvim = {
          enable = false;
          setupOpts.backend = "kitty";
        };
        images.img-clip.enable = false;
      };

      vim.extraPlugins = {
        leetcode-nvim = {
          package = pkgs.vimPlugins.leetcode-nvim;
          after = [
            "plenary-nvim"
            "nui-nvim"
          ];
          setup = ''
            -- Proactively ensure the storage directories exist.
            -- vim.fn.stdpath("data") usually resolves to ~/.local/share/nvim
            -- vim.fn.stdpath("cache") usually resolves to ~/.cache/nvim
            local data_dir = vim.fn.stdpath("data") .. "/leetcode"
            local cache_dir = vim.fn.stdpath("cache") .. "/leetcode"

            -- The "p" flag tells mkdir to create parent directories as needed (like mkdir -p).
            vim.fn.mkdir(data_dir, "p")
            vim.fn.mkdir(cache_dir, "p")

            require('leetcode').setup({
              lang = "python3",
              image_support = true,

              picker = {
                provider = nil 
              },

              plugins = {
                non_standalone = true
              }
            })
          '';
        };
        nui-nvim = {
          package = pkgs.vimPlugins.nui-nvim;
        };
        plenary-nvim = {
          package = pkgs.vimPlugins.plenary-nvim;
        };
      };
    };
  };
}
