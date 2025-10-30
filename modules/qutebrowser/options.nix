{ ... }:
{
  programs.qutebrowser = {
    enable = true;

    searchEngines = {
      DEFAULT = "https://startpage.com/sp/search?query={}";
    };

    keyBindings = {
      normal = {
        "<Alt+h>" = "tab-prev";
        "<Alt+l>" = "tab-next";
        "<Alt+K>" = "scroll-page 0 -0.5";
        "<Alt+J>" = "scroll-page 0 0.5";
      };
    };

    settings = {
      colors.webpage.darkmode.enabled = true;
      content.blocking.enabled = true;
    };
  };
}
