{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.nvf = {

    settings = {
      # Override epwalsh/obsidian.nvim with obsidian-nvim/obsidian.nvim
      vim.pluginOverrides = {
        obsidian-nvim = pkgs.fetchFromGitHub {
          owner = "obsidian-nvim";
          repo = "obsidian.nvim";
          rev = "refs/tags/v3.14.4";
          hash = "sha256-1dZpxRZH56O8SefPEyc2CgWZDpIrqc78S5kxbt/WeRE=";
        };
        # obsidian-nvim = pkgs.vimUtils.buildVimPlugin {
        #   name = "obsidian-nvim-local";
        #   src = ../../obsidian.nvim;
        #   # Add this attribute to skip the failing modules
        #   nvimSkipModule = [
        #     "minimal"
        #     "obsidian.picker._mini"
        #     "obsidian.picker._fzf"
        #     "obsidian.picker._telescope"
        #     "obsidian.picker._snacks"
        #   ];
        # };
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

          # Specify where new obsidian images will be stored
          attachments.attachments.img_folder = "./assets/imgs";

          # Remove access to legacy commands (and warning)
          legacy_commands = false;

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
        };
      };
    };
  };
}
