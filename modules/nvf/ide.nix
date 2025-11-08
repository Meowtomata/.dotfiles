{ lib, ... }:
{
  programs.nvf.settings.vim = {
    # Treesitter
    treesitter = {
      enable = true;
    };

    # Autocompletion
    autocomplete.blink-cmp = {
      enable = true;

      setupOpts = {
        # Disables autocomplete when writing in markdown buffer
        # (by not including it below)
        sources.per_filetype.markdown = [
          "lsp"
          "path"
          "snippets"
        ];
      };
    };

    # LSPs
    lsp = {
      # enable global lsp functionality
      enable = true;
      formatOnSave = true;
    };

    diagnostics = {
      enable = true;

      config = {
        # virtual_text = true;
        virtual_lines = true;
      };

      nvim-lint = {
        enable = true;

        # https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file
        linters_by_ft = {
          # cpp = [ "cpplint" ];

        };
      };
    };

    languages = {
      python.enable = true;

      nix.enable = true;
      nix.lsp.enable = true;
      nix.treesitter.enable = true;
      nix.format.enable = true;
      nix.format.type = "nixfmt";

      clang.enable = true;

      # enable markdown language features
      markdown.enable = true;
      # markdown.lsp.enable = true;
      markdown.treesitter.enable = true;
      markdown.format.enable = true;
      # change formatter from atorcious default deno formatter
      markdown.format.type = "prettierd";
    };

    # Allows me to import lua code in files under the ./nvim/lua directory
    additionalRuntimePaths = [ ./nvim ];

    /*
        :Obsidian paste_img from obsidian-nvim/obsidian.nvim
        (and :ObsidianPasteImg from epwalsh/obsidian.nvim)

        Only supports .png format for pasting
        If I do, wl-copy < image.jpg, it will tell me that
        there is no image detected in clipboard

        So I used the code from the obsidian-nvim/obsidian.nvim repo
        and modified it to support image/jpeg (and eventually other formats too)

        Allowed by additionalRunTimePaths = [ ./nvim ],
        this code is placed under:
        ./nvim/lua/img_paste_override.lua
        ./nvim/lua/paste_img_override.lua
        and should run in that order
    */
    luaConfigRC.obsidian-paste-img-override = # lua
      ''
        -- import ./nvim/lua/img_paste_override.lua module
        require('img_paste_override')
        local status_ok, custom_img_paste = pcall(require, "img_paste_override")

        if status_ok then
          -- overwrite :Obsidian paste_img helper function to allow pasting .jpg imgs
          package.loaded["obsidian.img_paste"] = custom_img_paste
        else
          vim.notify(
            "Could not load custom obsidian image paste module. Using the default.",
            vim.log.levels.WARN
          )
        end

        -- import ./nvim/lua/paste_img_override.lua module
        require('paste_img_override')
        local status_ok, custom_img_paste = pcall(require, "paste_img_override")

        if status_ok then
          -- overwrite :Obsidian paste_img with function that accepts .jpg imgs
          package.loaded["obsidian.commands.paste_img"] = custom_img_paste
        else
          vim.notify(
            "Could not load custom obsidian image paste module. Using the default.",
            vim.log.levels.WARN
          )
        end
      '';

    /*
      I find it more readable (and potentially concise) to set my keymaps in lua
      So I will set them in native lua here
    */
    luaConfigRC.mappings = # lua
      ''
        -- function to swap opts and rhs for improved readability
        local function set_keymap(mode, lhs, opts, rhs)
          if rhs == nil then
            rhs = opts
            opts = {} 
          end
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Create user commands to more easily run as a bash option 
        local excluded_results = {
            '.bash_history',
            '.local',
            '.cache',
        }

        vim.api.nvim_create_user_command('SmartFind', function()
            require('snacks').picker.smart({
                cwd = '/home/meowster',
                hidden = true,
                exclude = excluded_results
            })
        end, {
            desc = 'Smart Find Files in /home/meowster'
        })

        vim.api.nvim_create_user_command('GrepFind', function()
            require('snacks').picker.grep({
                cwd = '/home/meowster',
                hidden = true,
                exclude = excluded_results
            })
        end, {
            desc = 'Grep Find Files in /home/meowster'
        })

        set_keymap('n', '<M-f>', { desc = 'Smart Find Files' }, '<cmd>SmartFind<CR>')
        set_keymap('n', '<M-g>', { desc = 'Grep' }, '<cmd>GrepFind<CR>')


        set_keymap('n', '<M-b>', { desc = 'Buffers Find' },
            function() Snacks.picker.buffers() end) 
        set_keymap('n', '<leader>sk', { desc = 'Keymaps' },
            function() Snacks.picker.keymaps() end) 
      '';

    utility.snacks-nvim = {
      enable = true;

      setupOpts = {
        picker = {
          enabled = true;
        };
        image = {
          enabled = true;

          # Needed for snacks to understand where images are located for loading
          # https://github.com/obsidian-nvim/obsidian.nvim/wiki/Images#viewing
          resolve =
            lib.generators.mkLuaInline # lua
              ''
                  function(path, src)
                   if require("obsidian.api").path_is_note(path) then
                      return require("obsidian.api").resolve_image_path(src)
                   end
                end,
              '';
        };
      };
    };
  };
}
