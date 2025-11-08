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

    # Snacks Stuff
    keymaps = [
      {
        key = "<M-b>";
        mode = [ "n" ];
        action = "<cmd>lua require('snacks.picker').buffers()<cr>";
        silent = true;
        desc = "Buffers Find";
      }
    ];

    /*
      I find it more readable (and potentially concise) to set my keymaps in lua
      So I will set them in native lua here

      If I wanted to split these out into modules, I could:
      1. add additionalRuntimePaths = [ ./nvim ],
      2. put my keymaps in a module like ./nvim/lua/keymaps.lua,
      3. add require('keymaps') below

      mappings is also the module name used by nvf to set keymaps
      naming the below mappings will not clear other keymaps
      feel free to check output with `nvf-print-config | nvim -c 'set filetype=lua`

      I believe if I ever wanted to override existing lua functions
      I could do so below as well
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

        local excluded_results = {
            '.bash_history',
            '.local',
            '.cache',
        }

        -- Top Pickers & Explorer
        set_keymap('n', '<M-f>', { desc = 'Smart Find Files' },
            function() Snacks.picker.smart({
                cwd = '/home/meowster', 
                hidden = true, 
                exclude= excluded_results
            }) end)

        set_keymap('n', '<M-g>', { desc = 'Grep' },
            function() Snacks.picker.grep({
                cwd = '/home/meowster', 
                hidden = true, 
                exclude= excluded_results
            }) end)

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
