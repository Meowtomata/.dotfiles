{ ... }:

{
  programs.nvf.settings.vim = {
    viAlias = true;
    undoFile.enable = true;

    options = {
      foldlevelstart = 99;
      shiftwidth = 4;
      tabstop = 4;
      linebreak = true;
      breakindent = true;
      tw = 80;
    };

    clipboard.enable = true;
    clipboard.providers.wl-copy.enable = true;
    clipboard.providers.xclip.enable = true;
    clipboard.registers = "unnamedplus";

    globals.mapleader = " ";
  };
}
