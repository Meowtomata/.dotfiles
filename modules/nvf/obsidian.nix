{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.nvf.settings.vim = {

    # Override epwalsh/obsidian.nvim with obsidian-nvim/obsidian.nvim
    # pluginOverrides = {
    #   obsidian-nvim = pkgs.fetchFromGitHub {
    #     owner = "obsidian-nvim";
    #     repo = "obsidian.nvim";
    #     rev = "v3.14.7";
    #     hash = "sha256-Gz5/DHNDVFy4tqWMyrmc3Rg7r1tGOx5330/B7r3OqiE=";
    #   };
    #
    #   # Example for overriding obsidian plugin with local version
    #   # obsidian-nvim = pkgs.vimUtils.buildVimPlugin {
    #   #   name = "obsidian-nvim-local";
    #   #   src = ../../obsidian.nvim;
    #   #   # Add this attribute to skip the failing modules
    #   #   nvimSkipModule = [
    #   #     "minimal"
    #   #     "obsidian.picker._mini"
    #   #     "obsidian.picker._fzf"
    #   #     "obsidian.picker._telescope"
    #   #     "obsidian.picker._snacks"
    #   #   ];
    #   # };
    # };
    #
    # autocmds = [
    #   {
    #     event = [ "FileType" ];
    #     pattern = [ "markdown" ];
    #     command = "setlocal conceallevel=2";
    #   }
    # ];

    notes.obsidian = {
      enable = false;

      setupOpts = {
        workspaces = [
          {
            name = "main";
            path = "${config.home.homeDirectory}/Obsidian/";
          }
        ];

        # This is necessary for blink autocomplete to work for some reason
        # completion = {
        #   nvim_cmp = false;
        #   blink = true;
        #   min_chars = 1;
        # };

        # I SPENT LIKE 3 HOURS TROUBLESHOOTING THIS
        # WHY TF IS IT 'snacks.pick' NOT 'snacks.picker'
        # AND WHY ISN'T THIS MENTIONED ANYWHERE IN THE README
        picker.name = "snacks.pick";

        attachments.img_folder = "/";

        # Remove access to legacy commands (and warning)
        legacy_commands = false;

        follow_img_func =
          lib.generators.mkLuaInline # lua
            ''
              function(url)
                local path = url
                local page = nil

                -- Check if there is an anchor (e.g., #page=10)
                local anchor = url:match("#(.+)$")
                if anchor then
                  -- Strip the anchor from the path
                  path = url:match("^(.-)#")
                  -- Extract the page number
                  page = anchor:match("page=(%d+)")
                end

                if path:match("%.pdf$") then
                  local cmd = { "zathura" }
                  
                  -- Add page argument if we found one
                  if page then
                    table.insert(cmd, "--page=" .. page)
                  end
                  
                  table.insert(cmd, path)
                  
                  -- Run silently in background
                  vim.fn.jobstart(cmd, { detach = true })
                else
                  vim.ui.open(url)
                end
              end

            '';

        # Adapted from https://github.com/obsidian-nvim/obsidian.nvim/blob/1db1841f99f496a7a453a31a156552686e4cfd8a/tests/test_note.lua#L13
        # note_id_func =
        #   lib.generators.mkLuaInline # lua
        #     ''
        #       function(title)
        #           local id = ""
        #           if title ~= nil then
        #             id = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        #           else
        #             for _ = 1, 4 do
        #               id = id .. string.char(math.random(65, 90))
        #             end
        #           end
        #           return tostring(os.time()) .. "-" .. id
        #         end
        #     '';
      };
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
      ''require('obsidian-2').setup() '';
    #   -- import ./nvim/lua/img_paste_override.lua module
    #   require('img_paste_override')
    #   local status_ok, custom_img_paste = pcall(require, "img_paste_override")
    #
    #   if status_ok then
    #     -- overwrite :Obsidian paste_img helper function to allow pasting .jpg imgs
    #     package.loaded["obsidian.img_paste"] = custom_img_paste
    #   else
    #     vim.notify(
    #       "Could not load custom obsidian image paste module. Using the default.",
    #       vim.log.levels.WARN
    #     )
    #   end
    #
    #   -- import ./nvim/lua/paste_img_override.lua module
    #   require('paste_img_override')
    #   local status_ok, custom_img_paste = pcall(require, "paste_img_override")
    #
    #   if status_ok then
    #     -- overwrite :Obsidian paste_img with function that accepts .jpg imgs
    #     package.loaded["obsidian.commands.paste_img"] = custom_img_paste
    #   else
    #     vim.notify(
    #       "Could not load custom obsidian image paste module. Using the default.",
    #       vim.log.levels.WARN
    #     )
    #   end
    # '';
    utility.images.img-clip = {
      enable = true;
      setupOpts = {
        default = {
          dir_path = ".";
          relative_to_current_file = true;
          file_name = "IMG - %Y-%m-%d-at-%H-%M-%S";
        };
        filetypes = {
          markdown = {
            template = "![[$FILE_NAME]]";
          };

        };

      };
    };

    utility.snacks-nvim = {
      enable = true;

      setupOpts = {
        picker = {
          enabled = true;
        };

        lazygit.enabled = true;
        gh.enabled = true;

        image = {
          enabled = true;
          doc = {
            enabled = true;
            max_width = 30;
            max_height = 15;
          };

          # Needed for snacks to understand where images are located for loading
          # https://github.com/obsidian-nvim/obsidian.nvim/wiki/Images#viewing
          # resolve =
          #   lib.generators.mkLuaInline # lua
          #     ''
          #         function(path, src)
          #          if require("obsidian.api").path_is_note(path) then
          #             return require("obsidian.api").resolve_image_path(src)
          #          end
          #       end,
          #     '';
        };
      };
    };
  };
}
