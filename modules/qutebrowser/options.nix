{ pkgs, ... }:
{
  # options can be found on
  # https://home-manager-options.extranix.com/?query=qutebrowser&release=release-25.05
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
      content.pdfjs = true;
    };

    greasemonkey = [
      (pkgs.writeText "clean-reddit-homepage.js" ''
        // ==UserScript==
        // @name        Clean Reddit Homepage
        // @description Removes specific elements from the Reddit homepage
        // @match       https://www.reddit.com/
        // @match       https://reddit.com/
        // @run-at      document-idle
        // ==/UserScript==

        document.querySelector("body > shreddit-app > div").remove();
      '')
    ];

  };
}
