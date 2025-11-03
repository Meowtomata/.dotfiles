{ ... }:

{
  programs.nvf.settings.vim = {

    keymaps = [
      # snacks.nvim picker
      {
        key = "<M-g>";
        mode = [ "n" ];
        action = "<cmd>lua require('snacks.picker').grep({cwd = '/home/meowster', hidden = true, exclude= { '.bash_history' }})<cr>";
        silent = true;
        desc = "Live Grep";
      }
      {
        key = "<M-f>";
        mode = [ "n" ];
        action = "<cmd>lua require('snacks.picker').smart({cwd = '/home/meowster', hidden = true, exclude= { '.bash_history' } })<cr>";
        silent = true;
        desc = "Smart Find";
      }
      {
        key = "<M-b>";
        mode = [ "n" ];
        action = "<cmd>lua require('snacks.picker').buffers()<cr>";
        silent = true;
        desc = "Smart Find";
      }
    ];

    utility.snacks-nvim = {
      enable = true;

      setupOpts = {
        picker = {
          enabled = true;
        };
        image = {
          enabled = true;
        };
      };
    };
  };
}
