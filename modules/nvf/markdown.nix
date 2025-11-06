{ config, lib, ... }:

{
  programs.nvf = {
    settings = {

      vim.languages = {
        markdown.enable = true;
      };

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

          # Adapted from https://github.com/obsidian-nvim/obsidian.nvim/blob/1db1841f99f496a7a453a31a156552686e4cfd8a/tests/test_note.lua#L13
          note_id_func =
            lib.generators.mkLuaInline # lua
              ''
                function(title)
                    local id = ""
                    if title ~= nil then
                      id = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                    else
                      for _ = 1, 4 do
                        id = id .. string.char(math.random(65, 90))
                      end
                    end
                    return tostring(os.time()) .. "-" .. id
                  end
              '';

          follow_url_func =
            lib.generators.mkLuaInline # lua
              ''
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
