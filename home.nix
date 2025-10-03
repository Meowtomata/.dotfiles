{ config, pkgs, lib, leetcode-tui, ... }:

# https://nix-community.github.io/home-manager/options.xhtml
{
  home.username = "meowster";
  home.homeDirectory = "/home/meowster";
  programs.git.enable = true;
  home.stateVersion = "25.05";

  imports = [
    ./modules/hyprland/default.nix
  ];

  home.packages = [
    leetcode-tui.packages.${pkgs.system}.default
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      lg="lazygit";
      le="nvim leetcode.nvim";
    };
  };

  programs.qutebrowser = {
    enable = true; 

    searchEngines = {
      DEFAULT = "https://startpage.com/sp/search?query={}";
    };

    keyBindings = {
        normal = {
          "<Alt+h>" = "tab-prev";
          "<Alt+l>" = "tab-next";
          "<Alt+K>" = "scroll-page 0 -0.5";
          "<Alt+J>" = "scroll-page 0 0.5";
        };
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

      vim.treesitter = {
        enable = true;
      };

      vim.autocomplete.blink-cmp.enable = true;

      vim.languages = {
        python.enable = true;
        markdown.enable = true;
        nix.enable = true;
      };

      vim.notes.obsidian = {
        enable = true;

        setupOpts = {
          workspaces = [
              {
                name = "main"; 
                path = "${config.home.homeDirectory}/Obsidian/";
              }
              {
                name = "test"; 
                path = "${config.home.homeDirectory}/test/";
              }
            ];
          follow_url_func = lib.generators.mkLuaInline ''
            function(url)
              if string.match(url, "^file:///") then
                local path = string.gsub(url, "^file://", "")
                vim.cmd("edit " .. vim.fn.fnameescape(path))
                return
              end

              local fallback_command = { "qutebrowser", url }

              local ok, workspace_id = pcall(function()
                local json_output = vim.fn.system("hyprctl activeworkspace -j")
                if vim.v.shell_error ~= 0 then return nil end
                return vim.fn.json_decode(json_output).id
              end)

              if not (ok and workspace_id) then
                vim.fn.jobstart(fallback_command)
                vim.notify("Opening " .. url .. " in qutebrowser (fallback)", "info")
                return
              end

              local rule = "workspace " .. workspace_id .. " silent, class:(?i)qutebrowser, once"
              local rule_command = { "hyprctl", "keyword", "windowrulev2", rule }

              local launch_command = { "qutebrowser", "--target", "window", url }

              vim.fn.jobstart(rule_command, {
                on_exit = function()
                  vim.fn.jobstart(launch_command)
                  vim.notify("Opening " .. url .. " in qutebrowser on workspace " .. workspace_id, "info")
                end,
              })
            end
          '';
        };

      };

      vim.clipboard.enable = true;
      vim.clipboard.providers.wl-copy.enable = true;
      vim.clipboard.registers = "unnamedplus";


      vim.globals.mapleader = " ";

      vim.binds.whichKey.enable = true;

      vim.keymaps = [
        {
          key = "<Tab>";
          mode = ["n"];
          action = "<cmd>bn<cr>";
          silent = true;
        }
        {
          key = "<S-Tab>";
          mode = ["n"];
          action = "<cmd>bp<cr>";
          silent = true;
        }
        # tmux navigator
        {
          key = "<M-l>";
          mode = ["n"];
          action = "<cmd>TmuxNavigateRight<cr>";
          silent = true;
        }
        {
          key = "<M-k>";
          mode = ["n"];
          action = "<cmd>TmuxNavigateUp<cr>";
          silent = true;
        }
        {
          key = "<M-j>";
          mode = ["n"];
          action = "<cmd>TmuxNavigateDown<cr>";
          silent = true;
        }
        {
          key = "<M-h>";
          mode = ["n"];
          action = "<cmd>TmuxNavigateLeft<cr>";
          silent = true;
        }
        # snacks.nvim picker
        {
          key = "<M-g>";
          mode = ["n"];
          action = "<cmd>lua require('snacks.picker').grep()<cr>";
          silent = true;
          desc = "Live Grep";
        }
        {
          key = "<M-f>";
          mode = ["n"];
          action = "<cmd>lua require('snacks.picker').smart({cwd = '/home/meowster', hidden = true})<cr>";
          silent = true;
          desc = "Smart Find";
        }
        {
          key = "<M-b>";
          mode = ["n"];
          action = "<cmd>lua require('snacks.picker').buffers()<cr>";
          silent = true;
          desc = "Smart Find";
        }
        # Obsidian Links
        #
        # Search links & files
        #
        {
          key = "<M-s>";
          mode = ["n"];
          action = "<cmd>ObsidianBacklinks<cr>";
          silent = true;
          desc = "Obsidian Backlinks";
        }
        {
          key = "<M-d>";
          mode = ["n"];
          action = "<cmd>ObsidianLinks<cr>";
          silent = true;
          desc = "Obsidian Links";
        }
        {
          key = "<M-w>";
          mode = ["o"];
          action = "<cmd>ObsidianSearch<cr>";
          silent = true;
          desc = "Obsidian Links";
        }
        # Create files/links
        {
          key = "<C-n>";
          mode = ["n"];
          action = "<cmd>ObsidianNew<cr>";
          silent = true;
          desc = "Create new obsidian note";
        }
      ];

      vim.options = {
        foldlevelstart = 99;
      };

      vim.autocmds = [
      {
        # Event: Trigger when Neovim detects a file's type
        event = [ "FileType" ];
        
        # Pattern: Only run for these specific filetypes
        pattern = [ "markdown" ];
        
        # Command: The command to execute.
        # Use `setlocal` to apply the setting ONLY to the current buffer.
        command = "setlocal conceallevel=2";
      }
      # You can add other autocmds here
      ];

      vim.utility = {
        oil-nvim = {
          enable = true;

          setupOpts = {
            view_options.show_hidden = true;
          };
        };

        snacks-nvim = {
          enable = true;

          setupOpts = {
            picker = { enabled = true; };
            # image = { enabled = true; };
          };
        };

        # used by leetcode-nvim
        images.image-nvim = { 
          enable = true; 
          setupOpts.backend = "kitty";
        };
      };

      vim.extraPlugins = {
        # plugin found on nixpkgs
        vim-tmux-navigator = {
          package = pkgs.vimPlugins.vim-tmux-navigator;
        };
        leetcode-nvim = {
          package = pkgs.vimPlugins.leetcode-nvim;
          after = ["plenary-nvim" "nui-nvim"];
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

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "M-a";

    baseIndex = 1;

    # Smart pane switching with awareness of Vim splits.
    # See: https://github.com/christoomey/vim-tmux-navigator
    extraConfig = ''
        set-option -g allow-passthrough on

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

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
}
