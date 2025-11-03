{...}: {
  programs.nvf.settings.vim = {
    keymaps = [
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
        key = "<M-o>";
        mode = ["n"];
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
      # Better Markdown Navigation
      {
        key = "j";
        mode = ["n"];
        action = "gj";
        silent = true;
      }
      {
        key = "k";
        mode = ["n"];
        action = "gk";
        silent = true;
      }
    ];
  };
}
