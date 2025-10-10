{ config, lib, ... }:

{
  programs.nvf = {
    settings = {

      vim.options = {
        foldlevelstart = 99;
        shiftwidth = 4;
        tabstop = 4;
        linebreak = true;
      };

      vim.languages = {
        markdown.enable = true;
        markdown.extensions.markview-nvim.enable = true;
      };

      vim.keymaps = [
        # Obsidian Links
        #
        # Search links & files
        #
        {
          key = "<M-s>";
          mode = [ "n" ];
          action = "<cmd>ObsidianBacklinks<cr>";
          silent = true;
          desc = "Obsidian Backlinks";
        }
        {
          key = "<M-d>";
          mode = [ "n" ];
          action = "<cmd>ObsidianLinks<cr>";
          silent = true;
          desc = "Obsidian Links";
        }
        {
          key = "<M-o>";
          mode = [ "n" ];
          action = "<cmd>ObsidianSearch<cr>";
          silent = true;
          desc = "Obsidian Links";
        }
        # Create files/links
        {
          key = "<C-n>";
          mode = [ "n" ];
          action = "<cmd>ObsidianNew<cr>";
          silent = true;
          desc = "Create new obsidian note";
        }
      ];

      vim.autocmds = [
        {
          event = [ "FileType" ];
          pattern = [ "markdown" ];
          command = "setlocal conceallevel=2";
        }
      ];

      vim.notes.obsidian = {
        enable = true;

        setupOpts = {
          workspaces = [
            {
              name = "main";
              path = "${config.home.homeDirectory}/Obsidian/";
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
    };
  };
}
