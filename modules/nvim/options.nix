{ ... }:

{
  programs.nvf = {
    settings = {
      vim.viAlias = true;
      vim.undoFile.enable = true;

      vim.options = {
        foldlevelstart = 99;
        shiftwidth = 4;
        tabstop = 4;
        linebreak = true;
      };

      vim.clipboard.enable = true;
      vim.clipboard.providers.wl-copy.enable = true;
      vim.clipboard.registers = "unnamedplus";

      vim.globals.mapleader = " ";
    };
  };
}
